import 'dart:convert';

/// Represents a single detected food item from Gemini analysis
class DetectedFood {
  final String foodName;
  final double estimatedWeightG;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;

  DetectedFood({
    required this.foodName,
    required this.estimatedWeightG,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
  });

  factory DetectedFood.fromJson(Map<String, dynamic> json) {
    return DetectedFood(
      foodName: json['food_name'] ?? 'Unknown',
      estimatedWeightG: (json['estimated_weight_g'] ?? 0).toDouble(),
      calories: (json['calories'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      fats: (json['fats'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'food_name': foodName,
      'estimated_weight_g': estimatedWeightG,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
    };
  }
}

/// Represents the complete food recognition result from Gemini
class FoodRecognitionResult {
  final List<DetectedFood> foods;
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFats;
  final String? rawResponse;
  final String? error;

  FoodRecognitionResult({
    required this.foods,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFats,
    this.rawResponse,
    this.error,
  });

  /// Parse JSON response from Gemini API
  factory FoodRecognitionResult.fromGeminiResponse(String? response) {
    if (response == null || response.isEmpty) {
      return FoodRecognitionResult(
        foods: [],
        totalCalories: 0,
        totalProtein: 0,
        totalCarbs: 0,
        totalFats: 0,
        error: 'No response from AI',
      );
    }

    try {
      // Clean up response - remove markdown code blocks if present
      String cleanedResponse = response.trim();
      if (cleanedResponse.startsWith('```json')) {
        cleanedResponse = cleanedResponse.substring(7);
      } else if (cleanedResponse.startsWith('```')) {
        cleanedResponse = cleanedResponse.substring(3);
      }
      if (cleanedResponse.endsWith('```')) {
        cleanedResponse = cleanedResponse.substring(0, cleanedResponse.length - 3);
      }
      cleanedResponse = cleanedResponse.trim();

      // Parse JSON
      final dynamic decoded = jsonDecode(cleanedResponse);
      
      List<DetectedFood> foods = [];
      
      // Handle both array and object responses
      if (decoded is List) {
        foods = decoded.map((item) => DetectedFood.fromJson(item)).toList();
      } else if (decoded is Map<String, dynamic>) {
        // If it's an object, check for common wrapper keys
        if (decoded.containsKey('foods')) {
          foods = (decoded['foods'] as List).map((item) => DetectedFood.fromJson(item)).toList();
        } else if (decoded.containsKey('items')) {
          foods = (decoded['items'] as List).map((item) => DetectedFood.fromJson(item)).toList();
        } else {
          // Single food item
          foods = [DetectedFood.fromJson(decoded)];
        }
      }

      // Calculate totals
      double totalCalories = 0;
      double totalProtein = 0;
      double totalCarbs = 0;
      double totalFats = 0;

      for (var food in foods) {
        totalCalories += food.calories;
        totalProtein += food.protein;
        totalCarbs += food.carbs;
        totalFats += food.fats;
      }

      return FoodRecognitionResult(
        foods: foods,
        totalCalories: totalCalories,
        totalProtein: totalProtein,
        totalCarbs: totalCarbs,
        totalFats: totalFats,
        rawResponse: response,
      );
    } catch (e) {
      return FoodRecognitionResult(
        foods: [],
        totalCalories: 0,
        totalProtein: 0,
        totalCarbs: 0,
        totalFats: 0,
        rawResponse: response,
        error: 'Failed to parse response: $e',
      );
    }
  }

  bool get hasError => error != null;
  bool get isEmpty => foods.isEmpty;
  bool get hasResults => foods.isNotEmpty;
}
