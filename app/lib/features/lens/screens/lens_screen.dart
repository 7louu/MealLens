import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/object_detection_service.dart';
import '../services/food_recognition_service.dart';

class LensScreen extends ConsumerStatefulWidget {
  const LensScreen({super.key});

  @override
  ConsumerState<LensScreen> createState() => _LensScreenState();
}

class _LensScreenState extends ConsumerState<LensScreen> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isDetecting = false;
  int _frameCount = 0;
  List<Map<String, dynamic>> _detections = [];
  
  final ObjectDetectionService _objectDetectionService = ObjectDetectionService();
  final FoodRecognitionService _foodRecognitionService = FoodRecognitionService();

  @override
  void initState() {
    super.initState();
    _initializeAll();
  }

  Future<void> _initializeAll() async {
    await _objectDetectionService.initialize();
    await _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    // Use the back camera
    final camera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.yuv420 : ImageFormatGroup.bgra8888,
    );

    try {
      await _controller!.initialize();
      if (!mounted) return;
      
      setState(() {
        _isCameraInitialized = true;
      });

      _controller!.startImageStream((image) {
        if (!_isDetecting) {
          _isDetecting = true;
          _runDetection(image);
        }
      });
    } catch (e) {
      print('Camera initialization failed: $e');
    }
  }

  Future<void> _runDetection(CameraImage image) async {
    //Skip frames and only process every 10th frame
    _frameCount++;
    if (_frameCount % 10 != 0) {
      _isDetecting = false;
      return;
    }
    
    // Run inference
    final results = await _objectDetectionService.runInference(image);
    
    if (mounted) {
      setState(() {
        _detections = results;
      });
    }
    
    _isDetecting = false;
  }

  Future<void> _captureAndAnalyze() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      // Stop streaming to capture
      await _controller!.stopImageStream();
      
      final XFile file = await _controller!.takePicture();
      final File imageFile = File(file.path);

      // Show loading
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Analyze
      final result = await _foodRecognitionService.analyzeImage(imageFile);
      
      if (!mounted) return;
      Navigator.pop(context); // Hide loading

      // Show result
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Text(result ?? "No food detected or error occurred."),
          ),
        ),
      );

      // Restart stream
      _controller!.startImageStream((image) {
        if (!_isDetecting) {
          _isDetecting = true;
          _runDetection(image);
        }
      });

    } catch (e) {
      print("Error capturing: $e");
      if (mounted && Navigator.canPop(context)) Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _objectDetectionService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_controller!),
          // Bounding Boxes Overlay
          CustomPaint(
            painter: BoundingBoxPainter(_detections),
            child: Container(),
          ),
          // UI Overlay
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: _captureAndAnalyze,
                backgroundColor: Colors.white,
                child: const Icon(Icons.camera_alt, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BoundingBoxPainter extends CustomPainter {
  final List<Map<String, dynamic>> detections;

  BoundingBoxPainter(this.detections);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      backgroundColor: Colors.green,
    );

    for (var detection in detections) {
      // Assuming detection has 'rect' (Rect) and 'label' (String)
      // Note: Coordinates need to be scaled to screen size!
      // For now, we skip scaling logic as it requires knowing image size vs screen size
      if (detection['rect'] != null) {
        canvas.drawRect(detection['rect'], paint);
        
        final textSpan = TextSpan(
          text: detection['label'],
          style: textStyle,
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(detection['rect'].left, detection['rect'].top - 20));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}