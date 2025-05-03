import 'package:flutter/material.dart';
import 'foodSearchScreen.dart';
import '../models/meal_item_model.dart';
import '../models/food_model.dart';
import '../widgets/quantitySelectionDialog.dart';

class MealEditScreen extends StatefulWidget {
  const MealEditScreen({Key? key}) : super(key: key);

  @override
  State<MealEditScreen> createState() => MealEditScreenState();
}

class MealEditScreenState extends State<MealEditScreen> {
  List<MealItem> selectedItems = [];

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Meal")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: openFoodSearch,
            child: const Text("Add Food"),
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
        ],
      ),
    );
  }
}
