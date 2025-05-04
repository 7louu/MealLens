import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_model.dart';

class FoodService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Adds or updates a food item using the FoodModel.
  Future<void> addOrUpdateFood(Food food) async {
    final docRef = firestore.collection('foods').doc(food.id.isEmpty ? null : food.id);
    await docRef.set(food.toMap(), SetOptions(merge: true));
  }

  /// Retrieves a single food item by ID and maps it to FoodModel.
  Future<Food?> getFoodById(String foodId) async {
    final snap = await firestore.collection('foods').doc(foodId).get();
    if (!snap.exists) return null;
    return Food.fromMap(snap.data()!, snap.id);
  }

  /// Retrieves all food items as a list of FoodModel.
  Future<List<Food>> getAllFoods() async {
    final query = await firestore.collection('foods').get();
    return query.docs
        .map((doc) => Food.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Deletes a food item by ID.
  Future<void> deleteFood(String foodId) async {
    await firestore.collection('foods').doc(foodId).delete();
  }
}
