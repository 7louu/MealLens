import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../food/screens/food_search_screen.dart';

import '../../../shared/models/meal_item_model.dart';
import '../../../shared/models/food_model.dart';
import '../../../shared/widgets/quantity_selection_dialog.dart';
import '../../../routes/routes.dart';

class MealEditScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const MealEditScreen({Key? key, this.selectedDate}) : super(key: key);

  @override
  State<MealEditScreen> createState() => MealEditScreenState();
}

class MealEditScreenState extends State<MealEditScreen> {
  final TextEditingController _titleController = TextEditingController();
  List<MealItem> selectedItems = [];
  List<Food> selectedFoods = []; // Keep track of food details for display
  bool _isSaving = false;

  DateTime get _targetDate => widget.selectedDate ?? DateTime.now();

  double get totalCalories =>
      selectedItems.fold(0.0, (sum, item) => sum + item.calories);
  double get totalProtein =>
      selectedItems.fold(0.0, (sum, item) => sum + item.protein);
  double get totalCarbs =>
      selectedItems.fold(0.0, (sum, item) => sum + item.carbs);
  double get totalFat => selectedItems.fold(0.0, (sum, item) => sum + item.fat);

  void addFoodItem(Food item) async {
    final weight = await showDialog<double>(
      context: context,
      builder: (_) => QuantitySelectionDialog(foodItem: item),
    );

    if (weight != null) {
      setState(() {
        selectedFoods.add(item);
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

  void removeItem(int index) {
    setState(() {
      selectedItems.removeAt(index);
      selectedFoods.removeAt(index);
    });
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.close, color: Colors.black87, size: 20),
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.mainScreen);
          },
        ),
        title: const Text(
          "Create Meal",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meal Title Input
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _titleController,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter meal name (e.g., Breakfast)',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(
                          Icons.restaurant_menu,
                          color: Colors.orange[400],
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nutrition Summary Card
                  if (selectedItems.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade600,
                            Colors.green.shade400,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Meal Summary',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildSummaryItem(
                                'Calories',
                                '${totalCalories.round()}',
                                'kcal',
                              ),
                              _buildSummaryItem(
                                'Protein',
                                '${totalProtein.round()}',
                                'g',
                              ),
                              _buildSummaryItem(
                                'Carbs',
                                '${totalCarbs.round()}',
                                'g',
                              ),
                              _buildSummaryItem(
                                'Fat',
                                '${totalFat.round()}',
                                'g',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Food Items Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Food Items',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: openFoodSearch,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange[400],
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 18),
                              SizedBox(width: 4),
                              Text(
                                'Add Food',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Food Items List or Empty State
                  if (selectedItems.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.fastfood_outlined,
                            size: 48,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No food items added',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap "Add Food" to search and add items',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...List.generate(selectedItems.length, (index) {
                      final item = selectedItems[index];
                      final food = selectedFoods[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildFoodItemCard(food, item, index),
                      );
                    }),
                ],
              ),
            ),
          ),

          // Save Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedItems.isEmpty ? Colors.grey[300] : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed:
                      selectedItems.isEmpty || _isSaving ? null : _saveMeal,
                  child:
                      _isSaving
                          ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                          : Text(
                            selectedItems.isEmpty
                                ? 'Add food to save'
                                : 'Save Meal',
                            style: TextStyle(
                              color:
                                  selectedItems.isEmpty
                                      ? Colors.grey[500]
                                      : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '$label ($unit)',
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildFoodItemCard(Food food, MealItem item, int index) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getCategoryColor(food.category).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(food.category),
              color: _getCategoryColor(food.category),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${item.weightGram.round()}g',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'P:${item.protein.round()}g  C:${item.carbs.round()}g  F:${item.fat.round()}g',
                      style: TextStyle(color: Colors.grey[500], fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.calories.round()}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'kcal',
                style: TextStyle(color: Colors.grey[500], fontSize: 11),
              ),
            ],
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => removeItem(index),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.delete_outline,
                color: Colors.red[400],
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'fruit':
        return Colors.red;
      case 'vegetable':
        return Colors.green;
      case 'grain':
        return Colors.amber;
      case 'protein':
        return Colors.brown;
      case 'dairy':
        return Colors.blue;
      case 'beverage':
        return Colors.cyan;
      case 'snack':
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fruit':
        return Icons.apple;
      case 'vegetable':
        return Icons.eco;
      case 'grain':
        return Icons.breakfast_dining;
      case 'protein':
        return Icons.set_meal;
      case 'dairy':
        return Icons.water_drop;
      case 'beverage':
        return Icons.local_cafe;
      case 'snack':
        return Icons.cookie;
      default:
        return Icons.restaurant;
    }
  }

  Future<void> _saveMeal() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Use selected date but preserve current time for ordering
      final now = DateTime.now();
      final mealTimestamp = DateTime(
        _targetDate.year,
        _targetDate.month,
        _targetDate.day,
        now.hour,
        now.minute,
        now.second,
      );

      final mealData = {
        'userId': user.uid,
        'title':
            _titleController.text.trim().isEmpty
                ? 'Untitled Meal'
                : _titleController.text.trim(),
        'timestamp': mealTimestamp,
        'imageUrl': null,
        'items': selectedItems.map((item) => item.toMap()).toList(),
        'totalCalories': totalCalories,
        'totalProtein': totalProtein,
        'totalCarbs': totalCarbs,
        'totalFat': totalFat,
      };

      await FirebaseFirestore.instance.collection('meals').add(mealData);
      Navigator.pushReplacementNamed(context, AppRoutes.mainScreen);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save meal: $e')));
      setState(() => _isSaving = false);
    }
  }
}
