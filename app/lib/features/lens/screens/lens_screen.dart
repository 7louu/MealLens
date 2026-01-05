import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/object_detection_service.dart';
import '../services/food_recognition_service.dart';
import '../models/food_recognition_result.dart';

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
      if (kDebugMode) debugPrint('Camera initialization failed: $e');
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
        builder: (context) => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text('Analyzing food...', style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ),
      );

      // Analyze
      final rawResult = await _foodRecognitionService.analyzeImage(imageFile);
      final result = FoodRecognitionResult.fromGeminiResponse(rawResult);
      
      if (!mounted) return;
      Navigator.pop(context); // Hide loading

      // Show formatted result
      _showResultsBottomSheet(result);

      // Restart stream
      _controller!.startImageStream((image) {
        if (!_isDetecting) {
          _isDetecting = true;
          _runDetection(image);
        }
      });

    } catch (e) {
      if (kDebugMode) debugPrint('Error capturing: $e');
      if (mounted && Navigator.canPop(context)) Navigator.pop(context);
    }
  }

  void _showResultsBottomSheet(FoodRecognitionResult result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => _buildResultsContent(result, scrollController),
      ),
    );
  }

  Widget _buildResultsContent(FoodRecognitionResult result, ScrollController scrollController) {
    if (result.hasError) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Analysis Error', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(result.error ?? 'Unknown error occurred'),
            if (result.rawResponse != null) ...[
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text('Raw Response'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(result.rawResponse!, style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    }

    if (result.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.no_food, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No food detected', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Try taking another photo with better lighting'),
          ],
        ),
      );
    }

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        // Handle bar
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        
        // Title
        Text(
          'Food Analysis Results',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Totals Summary Card
        Card(
          color: Colors.green[50],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Nutrition', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNutrientColumn('Calories', '${result.totalCalories.toStringAsFixed(0)}', 'kcal', Colors.orange),
                    _buildNutrientColumn('Protein', '${result.totalProtein.toStringAsFixed(1)}', 'g', Colors.red),
                    _buildNutrientColumn('Carbs', '${result.totalCarbs.toStringAsFixed(1)}', 'g', Colors.blue),
                    _buildNutrientColumn('Fat', '${result.totalFats.toStringAsFixed(1)}', 'g', Colors.purple),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Individual foods
        Text(
          'Detected Items (${result.foods.length})',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        
        ...result.foods.map((food) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.restaurant, color: Colors.white),
            ),
            title: Text(food.foodName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${food.estimatedWeightG.toStringAsFixed(0)}g • ${food.calories.toStringAsFixed(0)} kcal'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('P: ${food.protein.toStringAsFixed(1)}g', style: const TextStyle(fontSize: 11)),
                Text('C: ${food.carbs.toStringAsFixed(1)}g', style: const TextStyle(fontSize: 11)),
                Text('F: ${food.fats.toStringAsFixed(1)}g', style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),
        )),

        const SizedBox(height: 24),

        // Save button
        ElevatedButton.icon(
          onPressed: () => _saveMealToFirestore(result),
          icon: const Icon(Icons.save),
          label: const Text('Save as Meal'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 8),
        
        // Retake button
        OutlinedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.camera_alt),
          label: const Text('Take Another Photo'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildNutrientColumn(String label, String value, String unit, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(unit, style: TextStyle(fontSize: 12, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Future<void> _saveMealToFirestore(FoodRecognitionResult result) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to save meals')),
      );
      return;
    }

    try {
      // Show saving indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Create meal document
      final mealData = {
        'userId': user.uid,
        'title': 'Lens Scan - ${DateTime.now().toString().substring(0, 16)}',
        'items': result.foods.map((food) => {
          'foodName': food.foodName,
          'weightGram': food.estimatedWeightG,
          'calories': food.calories,
          'protein': food.protein,
          'carbs': food.carbs,
          'fat': food.fats,
        }).toList(),
        'totalCalories': result.totalCalories,
        'totalProtein': result.totalProtein,
        'totalCarbs': result.totalCarbs,
        'totalFat': result.totalFats,
        'timestamp': FieldValue.serverTimestamp(),
        'source': 'lens_scan',
      };

      await FirebaseFirestore.instance.collection('meals').add(mealData);

      if (!mounted) return;
      Navigator.pop(context); // Hide loading
      Navigator.pop(context); // Close bottom sheet

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Meal saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Hide loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving meal: $e'), backgroundColor: Colors.red),
        );
      }
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