import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../food/screens/food_search_screen.dart';

import '../../../shared/models/meal_item_model.dart';
import '../../../shared/models/food_model.dart';
import '../../../shared/widgets/quantity_selection_dialog.dart';
import '../../../routes/routes.dart';

class MealEditScreen extends StatefulWidget {
  const MealEditScreen({Key? key}) : super(key: key);

  @override
  State<MealEditScreen> createState() => MealEditScreenState();
}

class MealEditScreenState extends State<MealEditScreen> {
  final TextEditingController _titleController = TextEditingController();
  List<MealItem> selectedItems = [];
  bool _isSaving = false;

  void addFoodItem(Food item) async {
    final weight = await showDialog<double>(
      context: context,
      builder: (_) => QuantitySelectionDialog(foodItem: item),
    );

    if (weight != null) {
      setState(() {
        selectedItems.add(
          MealItem(
            foodId: item.id,
            weightGram: weight,
            calories: item.caloriesPerGram * weight,
            protein: item.proteinPerGram * weight,
            carbs: item.carbsPerGram * weight,
            fat: item.fatPerGram * weight,
          ),
        );
      });
    }
  }

  void openFoodSearch() async {
    final selectedFood = await Navigator.push<Food>(
      context,
      MaterialPageRoute(builder: (_) => const FoodSearchScreen()),
    );

    if (selectedFood != null) {
      addFoodItem(selectedFood);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.mainScreen);
          },
        ),
        title: const Text("Edit Meal", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black, size: 33),
            onPressed: openFoodSearch,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Meal Title',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: selectedItems.length,
              itemBuilder: (_, index) {
                final item = selectedItems[index];
                return ListTile(
                  title: Text("Food ID: ${item.foodId}"),
                  subtitle: Text("Weight: ${item.weightGram.toStringAsFixed(1)} g"),
                  trailing: Text("${item.calories.toStringAsFixed(0)} kcal"),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _isSaving ? null : () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User not logged in')),
                    );
                    return;
                  }

                  setState(() => _isSaving = true);

                  final userId = user.uid;
                  final timestamp = DateTime.now();

                  final totalCalories = selectedItems.fold(0.0, (sum, item) => sum + item.calories);
                  final totalProtein = selectedItems.fold(0.0, (sum, item) => sum + item.protein);
                  final totalCarbs = selectedItems.fold(0.0, (sum, item) => sum + item.carbs);
                  final totalFat = selectedItems.fold(0.0, (sum, item) => sum + item.fat);

                  final mealData = {
                    'userId': userId,
                    'title': _titleController.text.trim().isEmpty
                        ? 'Untitled Meal'
                        : _titleController.text.trim(),
                    'timestamp': timestamp,
                    'imageUrl': null,
                    'items': selectedItems.map((item) => item.toMap()).toList(),
                    'totalCalories': totalCalories,
                    'totalProtein': totalProtein,
                    'totalCarbs': totalCarbs,
                    'totalFat': totalFat,
                  };

                  await FirebaseFirestore.instance.collection('meals').add(mealData);

                  Navigator.pushReplacementNamed(context, AppRoutes.mainScreen);
                },
                child: _isSaving 
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        "Save Meal",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
