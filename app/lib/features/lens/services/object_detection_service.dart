import 'dart:typed_data';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';

class ObjectDetectionService {
  OrtSession? _session;
  List<String> _labels = [];
  bool _isInitialized = false;

  Future<void> initialize() async {
    print("ObjectDetectionService: Initializing...");
    try {
      // Load ONNX model
      print("ObjectDetectionService: Loading model from assets/ai_models/yolo11n.onnx...");
      final ort = OnnxRuntime();
      _session = await ort.createSessionFromAsset('assets/ai_models/yolo11n.onnx');
      print("ObjectDetectionService: Model loaded successfully.");

      // Load labels
      print("ObjectDetectionService: Loading labels...");
      final labelsData = await rootBundle.loadString('assets/ai_models/labels.txt');
      _labels = labelsData.split('\n').where((line) => line.trim().isNotEmpty).toList();
      print("ObjectDetectionService: Loaded ${_labels.length} labels.");

      _isInitialized = true;
      print("ObjectDetectionService: Initialization Complete!");
    } catch (e, stackTrace) {
      print("ObjectDetectionService: Failed to initialize: $e");
      print("Stack trace: $stackTrace");
      _isInitialized = false;
    }
  }

  Future<List<Map<String, dynamic>>> runInference(CameraImage image) async {
    if (!_isInitialized || _session == null) {
      print("ObjectDetectionService: Not initialized");
      return [];
    }

    try {
      // Convert YUV to RGB
      final rgbImage = _convertCameraImage(image);
      if (rgbImage == null) {
        print("ObjectDetectionService: Image conversion failed");
        return [];
      }

      // Resize to 640x640 (YOLO11 input size)
      final resized = img.copyResize(rgbImage, width: 640, height: 640);

      // Normalize and convert to Float32 [1, 3, 640, 640] format
      final input = Float32List(1 * 3 * 640 * 640);
      
      int pixelIndex = 0;
      for (int y = 0; y < 640; y++) {
        for (int x = 0; x < 640; x++) {
          final pixel = resized.getPixel(x, y);
          // RGB channels, normalized to [0, 1]
          input[pixelIndex] = pixel.r / 255.0;
          input[pixelIndex + 640 * 640] = pixel.g / 255.0;
          input[pixelIndex + 640 * 640 * 2] = pixel.b / 255.0;
          pixelIndex++;
        }
      }

      // Run inference
      final inputOrt = await OrtValue.fromList(input, [1, 3, 640, 640]);
      final inputs = {'images': inputOrt};
      final outputs = await _session!.run(inputs);

      // Process outputs
      final detections = await _postProcess(outputs, image.width, image.height);

      print("ObjectDetectionService: Inference complete. Found ${detections.length} detections.");
      return detections;
    } catch (e) {
      print("ObjectDetectionService: Inference error: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _postProcess(
    Map<String, OrtValue> outputs,
    int originalWidth,
    int originalHeight,
  ) async {
    try {
      // YOLO11 output format: [1, 84, 8400]
      // 84 = 4 (bbox) + 80 (classes)
      final output = outputs.values.first;
      final outputData = await output.asList();
      
      // Debug: Print output structure
      print("ObjectDetectionService: Output type: ${outputData.runtimeType}");
      print("ObjectDetectionService: Output length: ${outputData.length}");
      if (outputData.isNotEmpty) {
        final batch = outputData[0];
        print("ObjectDetectionService: Batch type: ${batch.runtimeType}");
        if (batch is List) {
          print("ObjectDetectionService: Batch length: ${batch.length}");
          if (batch.isNotEmpty) {
            final firstRow = batch[0];
            print("ObjectDetectionService: First row type: ${firstRow.runtimeType}");
            if (firstRow is List) {
              print("ObjectDetectionService: First row length: ${firstRow.length}");
            }
          }
        }
      }

      final detections = <Map<String, dynamic>>[];
      const confThreshold = 0.15;
      const iouThreshold = 0.45;

      // Parse detections
      final candidates = <Map<String, dynamic>>[];
      
      // outputData shape: [1, 84, 8400]
      final batch = outputData[0] as List;
      
      int highConfCount = 0;
      double maxConfSeen = 0.0;
      
      for (int i = 0; i < 8400; i++) {
        // Get detection data for this anchor
        final detection = <double>[];
        for (int j = 0; j < 84; j++) {
          final row = batch[j] as List;
          detection.add((row[i] as num).toDouble());
        }
        
        // Get class scores (indices 4-83)
        final classScores = detection.sublist(4, 84);
        final maxScore = classScores.reduce((a, b) => a > b ? a : b);
        
        if (maxScore > maxConfSeen) maxConfSeen = maxScore;
        if (maxScore > 0.05) highConfCount++; // Count anything above 5%
        
        if (maxScore > confThreshold) {
          final classId = classScores.indexOf(maxScore);
          
          // YOLO outputs coordinates in the model input space (640x640)
          // We need to scale them to the original camera image size
          final cx = detection[0];
          final cy = detection[1];
          final w = detection[2];
          final h = detection[3];
          
          // Scale from 640x640 to original image dimensions
          final scaleX = originalWidth / 640.0;
          final scaleY = originalHeight / 640.0;

          candidates.add({
            'classId': classId,
            'confidence': maxScore,
            'rect': Rect.fromLTWH(
              (cx - w / 2) * scaleX,
              (cy - h / 2) * scaleY,
              w * scaleX,
              h * scaleY,
            ),
          });
        }
      }

      print("ObjectDetectionService: Max confidence seen: $maxConfSeen");
      print("ObjectDetectionService: Detections > 5%: $highConfCount");
      print("ObjectDetectionService: Found ${candidates.length} candidates above threshold.");

      print("ObjectDetectionService: Found ${candidates.length} candidates.");
      if (candidates.isNotEmpty) {
        print("ObjectDetectionService: Highest confidence: ${candidates.map((c) => c['confidence']).reduce((a, b) => a > b ? a : b)}");
      }

      // Apply NMS
      candidates.sort((a, b) => (b['confidence'] as double).compareTo(a['confidence'] as double));
      
      for (var candidate in candidates) {
        bool keep = true;
        for (var detection in detections) {
          if (_iou(candidate['rect'], detection['rect']) > iouThreshold) {
            keep = false;
            break;
          }
        }
        if (keep) {
          detections.add({
            'rect': candidate['rect'],
            'label': _labels[candidate['classId']],
            'confidence': candidate['confidence'],
          });
        }
      }

      return detections;
    } catch (e) {
      print("ObjectDetectionService: Post-processing error: $e");
      return [];
    }
  }

  double _iou(Rect a, Rect b) {
    final intersection = a.intersect(b);
    if (intersection.isEmpty) return 0.0;
    final intersectionArea = intersection.width * intersection.height;
    final unionArea = a.width * a.height + b.width * b.height - intersectionArea;
    return intersectionArea / unionArea;
  }

  img.Image? _convertCameraImage(CameraImage image) {
    try {
      if (image.format.group == ImageFormatGroup.yuv420) {
        return _convertYUV420ToImage(image);
      } else if (image.format.group == ImageFormatGroup.bgra8888) {
        return _convertBGRA8888ToImage(image);
      }
      return null;
    } catch (e) {
      print("ObjectDetectionService: Image conversion error: $e");
      return null;
    }
  }

  img.Image _convertYUV420ToImage(CameraImage image) {
    final width = image.width;
    final height = image.height;
    final yPlane = image.planes[0];
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];

    final img.Image rgbImage = img.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final yIndex = y * yPlane.bytesPerRow + x;
        final uvIndex = (y ~/ 2) * uPlane.bytesPerRow + (x ~/ 2);

        final yValue = yPlane.bytes[yIndex];
        final uValue = uPlane.bytes[uvIndex];
        final vValue = vPlane.bytes[uvIndex];

        final r = (yValue + 1.402 * (vValue - 128)).clamp(0, 255).toInt();
        final g = (yValue - 0.344136 * (uValue - 128) - 0.714136 * (vValue - 128)).clamp(0, 255).toInt();
        final b = (yValue + 1.772 * (uValue - 128)).clamp(0, 255).toInt();

        rgbImage.setPixelRgb(x, y, r, g, b);
      }
    }

    return rgbImage;
  }

  img.Image _convertBGRA8888ToImage(CameraImage image) {
    return img.Image.fromBytes(
      width: image.width,
      height: image.height,
      bytes: image.planes[0].bytes.buffer,
      order: img.ChannelOrder.bgra,
    );
  }

  void dispose() {
    // OrtSession in flutter_onnxruntime doesn't have a release method
    // The session will be garbage collected automatically
    _session = null;
    _isInitialized = false;
  }
}
