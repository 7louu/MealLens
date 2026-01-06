import 'package:cloud_firestore/cloud_firestore.dart';
import 'meal_item_model.dart';

class Meal {
  final String id;
  final String userId;
  final String title;
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
    required this.title,
    required this.timestamp,
    this.imageUrl,
    required this.items,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
  });

  factory Meal.fromMap(Map<String, dynamic> data, String id) {
    // Handle timestamp safely - could be Timestamp, DateTime, or null
    DateTime timestamp;
    final tsData = data['timestamp'];
    if (tsData is Timestamp) {
      timestamp = tsData.toDate();
    } else if (tsData is DateTime) {
      timestamp = tsData;
    } else {
      timestamp = DateTime.now();
    }
    
    return Meal(
      id: id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? 'Untitled Meal',
      timestamp: timestamp,
      imageUrl: data['imageUrl'], // nullable, no issue
      items: (data['items'] as List?)?.map((item) =>
        MealItem.fromMap(item as Map<String, dynamic>)
      ).toList() ?? [],
      totalCalories: (data['totalCalories'] ?? 0).toDouble(),
      totalProtein: (data['totalProtein'] ?? 0).toDouble(),
      totalCarbs: (data['totalCarbs'] ?? 0).toDouble(),
      totalFat: (data['totalFat'] ?? 0).toDouble(),
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
