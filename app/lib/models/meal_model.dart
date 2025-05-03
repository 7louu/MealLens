import 'package:cloud_firestore/cloud_firestore.dart';
import 'meal_item_model.dart';

class Meal {
  final String id;
  final String userId;
  final DateTime timestamp;
  final String? imageUrl;
  final List<MealItem> items;
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;

  Meal({
    required this.id,
    required this.userId,
    required this.timestamp,
    this.imageUrl,
    required this.items,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
  });

  factory Meal.fromMap(Map<String, dynamic> data, String id) {
    return Meal(
      id: id,
      userId: data['userId'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'],
      items: (data['items'] as List)
          .map((item) => MealItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      totalCalories: (data['totalCalories'] as num).toDouble(),
      totalProtein: (data['totalProtein'] as num).toDouble(),
      totalCarbs: (data['totalCarbs'] as num).toDouble(),
      totalFat: (data['totalFat'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'timestamp': timestamp,
      'imageUrl': imageUrl,
      'items': items.map((item) => item.toMap()).toList(),
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFat': totalFat,
    };
  }
}
