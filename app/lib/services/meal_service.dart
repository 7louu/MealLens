import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meal_model.dart';
import '../models/meal_item_model.dart';

class MealService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Creates a new meal document in Firestore.
  Future<String> createMeal(Meal meal) async {
    final docRef = firestore.collection('meals').doc();
    await docRef.set(meal.toMap());
    return docRef.id;
  }

  /// Gets meals for a user and maps them to MealModel.
  Future<List<Meal>> getMealsByUser(String userId) async {
    final querySnap = await firestore
        .collection('meals')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();

    return querySnap.docs
        .map((doc) => Meal.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Updates a meal document by ID.
  Future<void> updateMeal(String mealId, Map<String, dynamic> updatedData) async {
    await firestore.collection('meals').doc(mealId).update(updatedData);
  }

  /// Deletes a meal document by ID.
  Future<void> deleteMeal(String mealId) async {
    await firestore.collection('meals').doc(mealId).delete();
  }
}
