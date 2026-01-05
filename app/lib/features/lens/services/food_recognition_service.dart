import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FoodRecognitionService {
  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? ''; 
  
  late final GenerativeModel _model;

  FoodRecognitionService() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: _apiKey,
    );
  }

  Future<String?> analyzeImage(File imageFile) async {
    try {
      final imageBytes = await imageFile.readAsBytes();
      final content = [
        Content.multi([
          TextPart('Analyze this image. Identify each food item. Estimate the weight/portion size of each item based on visual depth cues. Calculate calories and macros for each. Return a JSON list with fields: "food_name", "estimated_weight_g", "calories", "protein", "carbs", "fats". Do not include markdown formatting.'),
          DataPart('image/jpeg', imageBytes),
        ])
      ];

      final response = await _model.generateContent(content);
      return response.text;
    } catch (e) {
      if (kDebugMode) debugPrint('Error analyzing image: $e');
      return null;
    }
  }
}
