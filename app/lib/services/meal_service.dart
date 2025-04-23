import 'package:cloud_firestore/cloud_firestore.dart';

/// A service class to handle CRUD operations for the `meals` collection in Firestore.
/// Each meal document represents one logged meal by a user.
class MealService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Creates a new meal document for the given user.
  ///
  /// [userId]       : UID of the user logging the meal
  /// [items]        : List of maps representing each food item, e.g.
  ///                  { 'foodId': 'abc', 'weightGram': 150, 'calories': 75, ... }
  /// [timestamp]    : When the meal was logged (defaults to now if null)
  /// [imageUrl]     : Optional URL of the meal photo
  Future<String> createMeal({
    required String userId,
    required List<Map<String, dynamic>> items,
    DateTime? timestamp,
    String? imageUrl,
  }) async {
    final docRef = firestore.collection('meals').doc(); // auto-generated ID
    final ts = timestamp ?? DateTime.now();

    // Compute totals for convenience
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    for (var item in items) {
      totalCalories += (item['calories'] as num).toDouble();
      totalProtein  += (item['protein'] as num).toDouble();
      totalCarbs    += (item['carbs'] as num).toDouble();
      totalFat      += (item['fat'] as num).toDouble();
    }

    await docRef.set({
      'userId': userId,
      'timestamp': ts,
      'imageUrl': imageUrl,
      'items': items,
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFat': totalFat,
    });

    return docRef.id;
  }

  /// Retrieves all meals for a specific user, ordered by timestamp descending.
  Future<List<Map<String, dynamic>>> getMealsByUser(String userId) async {
    final querySnap = await firestore
        .collection('meals')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();

    return querySnap.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  /// Updates fields of an existing meal document.
  /// [mealId]      : ID of the meal document
  /// [updatedData] : Map of fields to update
  Future<void> updateMeal(String mealId, Map<String, dynamic> updatedData) async {
    await firestore.collection('meals').doc(mealId).update(updatedData);
  }

  /// Deletes a meal document by its ID.
  Future<void> deleteMeal(String mealId) async {
    await firestore.collection('meals').doc(mealId).delete();
  }
}
