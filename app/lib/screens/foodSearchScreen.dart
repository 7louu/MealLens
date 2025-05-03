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
