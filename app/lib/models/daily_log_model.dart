import 'package:cloud_firestore/cloud_firestore.dart';

class DailyMeal {
  final String mealId;
  final String mealName;
  final double mealCalories;
  final double mealProtein;
  final double mealCarbs;
  final double mealFat;
  final DateTime mealTime;

  DailyMeal({
    required this.mealId,
    required this.mealName,
    required this.mealCalories,
    required this.mealProtein,
    required this.mealCarbs,
    required this.mealFat,
    required this.mealTime,
  });

  factory DailyMeal.fromMap(Map<String, dynamic> data) {
    return DailyMeal(
      mealId: data['mealId'],
      mealName: data['mealName'],
      mealCalories: (data['mealCalories'] as num).toDouble(),
      mealProtein: (data['mealProtein'] as num).toDouble(),
      mealCarbs: (data['mealCarbs'] as num).toDouble(),
      mealFat: (data['mealFat'] as num).toDouble(),
      mealTime: (data['mealTime'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mealId': mealId,
      'mealName': mealName,
      'mealCalories': mealCalories,
      'mealProtein': mealProtein,
      'mealCarbs': mealCarbs,
      'mealFat': mealFat,
      'mealTime': mealTime,
    };
  }
}

class DailyLog {
  final String userId;
  final DateTime date;
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final List<DailyMeal> meals;

  DailyLog({
    required this.userId,
    required this.date,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.meals,
  });

  factory DailyLog.fromMap(Map<String, dynamic> data) {
    return DailyLog(
      userId: data['userId'],
      date: (data['date'] as Timestamp).toDate(),
      totalCalories: (data['totalCalories'] as num).toDouble(),
      totalProtein: (data['totalProtein'] as num).toDouble(),
      totalCarbs: (data['totalCarbs'] as num).toDouble(),
      totalFat: (data['totalFat'] as num).toDouble(),
      meals: (data['meals'] as List)
          .map((meal) => DailyMeal.fromMap(meal as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': date,
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFat': totalFat,
      'meals': meals.map((m) => m.toMap()).toList(),
    };
  }
}
