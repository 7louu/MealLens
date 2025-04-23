import 'package:cloud_firestore/cloud_firestore.dart';

/// A service class to handle CRUD operations for the `foods` collection in Firestore.
/// Each food item is stored as a document with nutritional data per gram.
class FoodService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Adds a new food item or updates an existing one.
  ///
  /// [foodId]        : Document ID (use auto-generated if creating new)
  /// [name]          : Name of the food (e.g., "Apple").
  /// [category]      : Food category (e.g., "fruit", "protein").
  /// [calPerGram]    : Calories per gram.
  /// [proteinPerGram]: Protein grams per gram of food.
  /// [carbsPerGram]  : Carbs grams per gram of food.
  /// [fatPerGram]    : Fat grams per gram of food.
  Future<void> addOrUpdateFood({
    String? foodId,
    required String name,
    required String category,
    required double calPerGram,
    required double proteinPerGram,
    required double carbsPerGram,
    required double fatPerGram,
  }) async {
    final CollectionReference foods = firestore.collection('foods');
    final docRef = foodId != null
        ? foods.doc(foodId)
        : foods.doc(); // auto-ID if none provided

    await docRef.set({
      'name': name,
      'category': category,
      'caloriesPerGram': calPerGram,
      'proteinPerGram': proteinPerGram,
      'carbsPerGram': carbsPerGram,
      'fatPerGram': fatPerGram,
    }, SetOptions(merge: true));
  }

  /// Retrieves a single food item by its document ID.
  /// Returns a map of the food fields or null if not found.
  Future<Map<String, dynamic>?> getFoodById(String foodId) async {
    final snap = await firestore.collection('foods').doc(foodId).get();
    return snap.exists ? snap.data() as Map<String, dynamic> : null;
  }

  /// Retrieves all food items in the `foods` collection.
  /// Returns a list of maps containing each food's fields including its ID.
  Future<List<Map<String, dynamic>>> getAllFoods() async {
    final querySnap = await firestore.collection('foods').get();
    return querySnap.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  /// Deletes a food item document by its ID.
  Future<void> deleteFood(String foodId) async {
    await firestore.collection('foods').doc(foodId).delete();
  }
}
