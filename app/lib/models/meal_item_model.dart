class MealItem {
  final String foodId;
  final double weightGram;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  MealItem({
    required this.foodId,
    required this.weightGram,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory MealItem.fromMap(Map<String, dynamic> data) {
    return MealItem(
      foodId: data['foodId'],
      weightGram: (data['weightGram'] as num).toDouble(),
      calories: (data['calories'] as num).toDouble(),
      protein: (data['protein'] as num).toDouble(),
      carbs: (data['carbs'] as num).toDouble(),
      fat: (data['fat'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foodId': foodId,
      'weightGram': weightGram,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }
}
