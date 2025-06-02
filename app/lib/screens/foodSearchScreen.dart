import 'package:flutter/material.dart';
import '../models/food_model.dart';

class FoodSearchScreen extends StatelessWidget {
  const FoodSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Food> foodList = [
      Food(
        id: "apple",
        name: "Apple",
        category: "Fruit",
        caloriesPerGram: 0.52,
        proteinPerGram: 0.0,
        carbsPerGram: 0.14,
        fatPerGram: 0.002,
      ),
      Food(
        id: "rice",
        name: "Rice (cooked)",
        category: "Grain",
        caloriesPerGram: 1.3,
        proteinPerGram: 0.026,
        carbsPerGram: 0.28,
        fatPerGram: 0.003,
      ),
      Food(
        id: "ChickenBreast",
        name: "Chicken Breast",
        category: "Protein",
        caloriesPerGram: 1.65,
        proteinPerGram: 0.31,
        carbsPerGram: 0.0,
        fatPerGram: 0.04,
      ),
      Food(
        id: "Broccoli",
        name: "Broccoli",
        category: "Vegetable",
        caloriesPerGram: 0.34,
        proteinPerGram: 0.028,
        carbsPerGram: 0.07,
        fatPerGram: 0.003,
      ),
      Food(
        id: "Salmon",
        name: "Salmon",
        category: "Protein",
        caloriesPerGram: 2.08,
        proteinPerGram: 0.20,
        carbsPerGram: 0.0,
        fatPerGram: 0.13,
      ),
      Food(
        id: "Avocado",
        name: "Avocado",
        category: "Fruit",
        caloriesPerGram: 1.6,
        proteinPerGram: 0.02,
        carbsPerGram: 0.08,
        fatPerGram: 0.15,
      ),
      Food(
        id: "Almonds",
        name: "Almonds",
        category: "Nuts",
        caloriesPerGram: 5.76,
        proteinPerGram: 0.21,
        carbsPerGram: 0.22,
        fatPerGram: 0.50,
      ),
      Food(
        id: "SweetPotato",
        name: "Sweet Potato",
        category: "Vegetable",
        caloriesPerGram: 0.86,
        proteinPerGram: 0.016,
        carbsPerGram: 0.20,
        fatPerGram: 0.003,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Search Food")),
      body: ListView.builder(
        itemCount: foodList.length,
        itemBuilder: (_, index) {
          final food = foodList[index];
          return ListTile(
            title: Text(food.name),
            subtitle: Text("${(food.caloriesPerGram * 100).toStringAsFixed(0)} kcal / 100g"),
            onTap: () {
              Navigator.pop(context, food);
            },
          );
        },
      ),
    );
  }
}
