import 'package:flutter/material.dart';
import 'foodSearchScreen.dart';
import '../models/logged_food_item.dart';
import '../models/food_item.dart';
import '../widgets/quantitySelectionDialog.dart';

class MealEditScreen extends StatefulWidget {
  const MealEditScreen({Key? key}) : super(key: key);

  @override
  State<MealEditScreen> createState() => MealEditScreenState();
}

class MealEditScreenState extends State<MealEditScreen> {
  List<LoggedFoodItem> _selectedItems = [];

  void addFoodItem(FoodItem item) async {
    final weight = await showDialog<double>(
      context: context,
      builder: (_) => QuantitySelectionDialog(foodItem: item),
    );

    if (weight != null) {
      setState(() {
        final multiplier = weight;
        selectedItems.add(
          LoggedFoodItem(
            foodId: item.id,
            weightGram: weight,
            calories: item.caloriesPerGram * multiplier,
            protein: item.proteinPerGram * multiplier,
            carbs: item.carbsPerGram * multiplier,
            fat: item.fatPerGram * multiplier,
          ),
        );
      });
    }
  }

  void openFoodSearch() async {
    final selectedFood = await Navigator.push<FoodItem>(
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
              itemCount: _selectedItems.length,
              itemBuilder: (_, index) {
                final item = _selectedItems[index];
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
