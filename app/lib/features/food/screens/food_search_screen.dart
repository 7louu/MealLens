import 'package:flutter/material.dart';
import '../../../shared/models/food_model.dart';

class FoodSearchScreen extends StatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;

  // Category styling
  static const Map<String, IconData> _categoryIcons = {
    'Fruit': Icons.apple,
    'Vegetable': Icons.eco,
    'Grain': Icons.grain,
    'Protein': Icons.fitness_center,
    'Dairy': Icons.water_drop,
    'Nuts': Icons.spa,
    'Seeds': Icons.grass,
    'Oil': Icons.opacity,
    'Legume': Icons.scatter_plot,
    'Snack': Icons.cookie,
    'Sweetener': Icons.cake,
    'Supplement': Icons.science,
  };

  static const Map<String, Color> _categoryColors = {
    'Fruit': Color(0xFFE91E63),
    'Vegetable': Color(0xFF4CAF50),
    'Grain': Color(0xFFFF9800),
    'Protein': Color(0xFFF44336),
    'Dairy': Color(0xFF2196F3),
    'Nuts': Color(0xFF795548),
    'Seeds': Color(0xFF8BC34A),
    'Oil': Color(0xFFFFEB3B),
    'Legume': Color(0xFF9C27B0),
    'Snack': Color(0xFFFF5722),
    'Sweetener': Color(0xFFFFC107),
    'Supplement': Color(0xFF00BCD4),
  };

  IconData _getCategoryIcon(String category) {
    return _categoryIcons[category] ?? Icons.restaurant;
  }

  Color _getCategoryColor(String category) {
    return _categoryColors[category] ?? Colors.grey;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Food> foodList = [
      Food(
        id: "apple",
        name: "Apple",
        category: "Fruit",
        caloriesPerGram: 0.52,
        proteinPerGram: 0.003,
        carbsPerGram: 0.14,
        fatPerGram: 0.002,
      ),
      Food(
        id: "banana",
        name: "Banana",
        category: "Fruit",
        caloriesPerGram: 0.89,
        proteinPerGram: 0.011,
        carbsPerGram: 0.23,
        fatPerGram: 0.003,
      ),
      Food(
        id: "orange",
        name: "Orange",
        category: "Fruit",
        caloriesPerGram: 0.47,
        proteinPerGram: 0.009,
        carbsPerGram: 0.12,
        fatPerGram: 0.001,
      ),
      Food(
        id: "strawberry",
        name: "Strawberry",
        category: "Fruit",
        caloriesPerGram: 0.32,
        proteinPerGram: 0.007,
        carbsPerGram: 0.08,
        fatPerGram: 0.003,
      ),
      Food(
        id: "grapes",
        name: "Grapes",
        category: "Fruit",
        caloriesPerGram: 0.69,
        proteinPerGram: 0.007,
        carbsPerGram: 0.18,
        fatPerGram: 0.002,
      ),
      Food(
        id: "watermelon",
        name: "Watermelon",
        category: "Fruit",
        caloriesPerGram: 0.30,
        proteinPerGram: 0.006,
        carbsPerGram: 0.08,
        fatPerGram: 0.002,
      ),
      Food(
        id: "mango",
        name: "Mango",
        category: "Fruit",
        caloriesPerGram: 0.60,
        proteinPerGram: 0.008,
        carbsPerGram: 0.15,
        fatPerGram: 0.004,
      ),
      Food(
        id: "pineapple",
        name: "Pineapple",
        category: "Fruit",
        caloriesPerGram: 0.50,
        proteinPerGram: 0.005,
        carbsPerGram: 0.13,
        fatPerGram: 0.001,
      ),

      // Vegetables
      Food(
        id: "broccoli",
        name: "Broccoli",
        category: "Vegetable",
        caloriesPerGram: 0.34,
        proteinPerGram: 0.028,
        carbsPerGram: 0.07,
        fatPerGram: 0.003,
      ),
      Food(
        id: "spinach",
        name: "Spinach",
        category: "Vegetable",
        caloriesPerGram: 0.23,
        proteinPerGram: 0.029,
        carbsPerGram: 0.04,
        fatPerGram: 0.004,
      ),
      Food(
        id: "carrot",
        name: "Carrot",
        category: "Vegetable",
        caloriesPerGram: 0.41,
        proteinPerGram: 0.009,
        carbsPerGram: 0.10,
        fatPerGram: 0.002,
      ),
      Food(
        id: "tomato",
        name: "Tomato",
        category: "Vegetable",
        caloriesPerGram: 0.18,
        proteinPerGram: 0.009,
        carbsPerGram: 0.04,
        fatPerGram: 0.002,
      ),
      Food(
        id: "cucumber",
        name: "Cucumber",
        category: "Vegetable",
        caloriesPerGram: 0.15,
        proteinPerGram: 0.007,
        carbsPerGram: 0.04,
        fatPerGram: 0.001,
      ),
      Food(
        id: "lettuce",
        name: "Lettuce",
        category: "Vegetable",
        caloriesPerGram: 0.15,
        proteinPerGram: 0.014,
        carbsPerGram: 0.03,
        fatPerGram: 0.002,
      ),
      Food(
        id: "sweetPotato",
        name: "Sweet Potato",
        category: "Vegetable",
        caloriesPerGram: 0.86,
        proteinPerGram: 0.016,
        carbsPerGram: 0.20,
        fatPerGram: 0.003,
      ),
      Food(
        id: "bell_pepper",
        name: "Bell Pepper",
        category: "Vegetable",
        caloriesPerGram: 0.31,
        proteinPerGram: 0.010,
        carbsPerGram: 0.06,
        fatPerGram: 0.003,
      ),

      // Grains
      Food(
        id: "rice",
        name: "White Rice (cooked)",
        category: "Grain",
        caloriesPerGram: 1.3,
        proteinPerGram: 0.026,
        carbsPerGram: 0.28,
        fatPerGram: 0.003,
      ),
      Food(
        id: "brown_rice",
        name: "Brown Rice (cooked)",
        category: "Grain",
        caloriesPerGram: 1.12,
        proteinPerGram: 0.026,
        carbsPerGram: 0.23,
        fatPerGram: 0.009,
      ),
      Food(
        id: "pasta",
        name: "Pasta (cooked)",
        category: "Grain",
        caloriesPerGram: 1.31,
        proteinPerGram: 0.051,
        carbsPerGram: 0.25,
        fatPerGram: 0.009,
      ),
      Food(
        id: "bread",
        name: "Whole Wheat Bread",
        category: "Grain",
        caloriesPerGram: 2.47,
        proteinPerGram: 0.13,
        carbsPerGram: 0.41,
        fatPerGram: 0.032,
      ),
      Food(
        id: "oats",
        name: "Oats (cooked)",
        category: "Grain",
        caloriesPerGram: 0.71,
        proteinPerGram: 0.024,
        carbsPerGram: 0.12,
        fatPerGram: 0.014,
      ),
      Food(
        id: "quinoa",
        name: "Quinoa (cooked)",
        category: "Grain",
        caloriesPerGram: 1.20,
        proteinPerGram: 0.043,
        carbsPerGram: 0.21,
        fatPerGram: 0.019,
      ),

      // Proteins
      Food(
        id: "chickenBreast",
        name: "Chicken Breast",
        category: "Protein",
        caloriesPerGram: 1.65,
        proteinPerGram: 0.31,
        carbsPerGram: 0.0,
        fatPerGram: 0.04,
      ),
      Food(
        id: "salmon",
        name: "Salmon",
        category: "Protein",
        caloriesPerGram: 2.08,
        proteinPerGram: 0.20,
        carbsPerGram: 0.0,
        fatPerGram: 0.13,
      ),
      Food(
        id: "tuna",
        name: "Tuna",
        category: "Protein",
        caloriesPerGram: 1.32,
        proteinPerGram: 0.30,
        carbsPerGram: 0.0,
        fatPerGram: 0.01,
      ),
      Food(
        id: "beef",
        name: "Lean Beef",
        category: "Protein",
        caloriesPerGram: 2.50,
        proteinPerGram: 0.26,
        carbsPerGram: 0.0,
        fatPerGram: 0.15,
      ),
      Food(
        id: "pork",
        name: "Pork Loin",
        category: "Protein",
        caloriesPerGram: 2.42,
        proteinPerGram: 0.27,
        carbsPerGram: 0.0,
        fatPerGram: 0.14,
      ),
      Food(
        id: "egg",
        name: "Egg",
        category: "Protein",
        caloriesPerGram: 1.55,
        proteinPerGram: 0.13,
        carbsPerGram: 0.01,
        fatPerGram: 0.11,
      ),
      Food(
        id: "tofu",
        name: "Tofu",
        category: "Protein",
        caloriesPerGram: 0.76,
        proteinPerGram: 0.08,
        carbsPerGram: 0.02,
        fatPerGram: 0.05,
      ),

      // Dairy
      Food(
        id: "milk",
        name: "Whole Milk",
        category: "Dairy",
        caloriesPerGram: 0.61,
        proteinPerGram: 0.033,
        carbsPerGram: 0.05,
        fatPerGram: 0.033,
      ),
      Food(
        id: "yogurt",
        name: "Greek Yogurt",
        category: "Dairy",
        caloriesPerGram: 0.59,
        proteinPerGram: 0.10,
        carbsPerGram: 0.04,
        fatPerGram: 0.004,
      ),
      Food(
        id: "cheese",
        name: "Cheddar Cheese",
        category: "Dairy",
        caloriesPerGram: 4.03,
        proteinPerGram: 0.25,
        carbsPerGram: 0.01,
        fatPerGram: 0.33,
      ),
      Food(
        id: "cottage_cheese",
        name: "Cottage Cheese",
        category: "Dairy",
        caloriesPerGram: 0.98,
        proteinPerGram: 0.11,
        carbsPerGram: 0.03,
        fatPerGram: 0.04,
      ),

      // Nuts & Seeds
      Food(
        id: "almonds",
        name: "Almonds",
        category: "Nuts",
        caloriesPerGram: 5.76,
        proteinPerGram: 0.21,
        carbsPerGram: 0.22,
        fatPerGram: 0.50,
      ),
      Food(
        id: "walnuts",
        name: "Walnuts",
        category: "Nuts",
        caloriesPerGram: 6.54,
        proteinPerGram: 0.15,
        carbsPerGram: 0.14,
        fatPerGram: 0.65,
      ),
      Food(
        id: "peanuts",
        name: "Peanuts",
        category: "Nuts",
        caloriesPerGram: 5.67,
        proteinPerGram: 0.26,
        carbsPerGram: 0.16,
        fatPerGram: 0.49,
      ),
      Food(
        id: "cashews",
        name: "Cashews",
        category: "Nuts",
        caloriesPerGram: 5.53,
        proteinPerGram: 0.18,
        carbsPerGram: 0.30,
        fatPerGram: 0.44,
      ),
      Food(
        id: "peanut_butter",
        name: "Peanut Butter",
        category: "Nuts",
        caloriesPerGram: 5.88,
        proteinPerGram: 0.25,
        carbsPerGram: 0.20,
        fatPerGram: 0.50,
      ),
      Food(
        id: "chia_seeds",
        name: "Chia Seeds",
        category: "Seeds",
        caloriesPerGram: 4.86,
        proteinPerGram: 0.17,
        carbsPerGram: 0.42,
        fatPerGram: 0.31,
      ),

      // Fats & Oils
      Food(
        id: "avocado",
        name: "Avocado",
        category: "Fruit",
        caloriesPerGram: 1.6,
        proteinPerGram: 0.02,
        carbsPerGram: 0.09,
        fatPerGram: 0.15,
      ),
      Food(
        id: "olive_oil",
        name: "Olive Oil",
        category: "Oil",
        caloriesPerGram: 8.84,
        proteinPerGram: 0.0,
        carbsPerGram: 0.0,
        fatPerGram: 1.0,
      ),

      // Legumes
      Food(
        id: "lentils",
        name: "Lentils (cooked)",
        category: "Legume",
        caloriesPerGram: 1.16,
        proteinPerGram: 0.09,
        carbsPerGram: 0.20,
        fatPerGram: 0.004,
      ),
      Food(
        id: "chickpeas",
        name: "Chickpeas (cooked)",
        category: "Legume",
        caloriesPerGram: 1.64,
        proteinPerGram: 0.09,
        carbsPerGram: 0.27,
        fatPerGram: 0.03,
      ),
      Food(
        id: "black_beans",
        name: "Black Beans (cooked)",
        category: "Legume",
        caloriesPerGram: 1.32,
        proteinPerGram: 0.09,
        carbsPerGram: 0.24,
        fatPerGram: 0.005,
      ),
      Food(
        id: "kidney_beans",
        name: "Kidney Beans (cooked)",
        category: "Legume",
        caloriesPerGram: 1.27,
        proteinPerGram: 0.09,
        carbsPerGram: 0.23,
        fatPerGram: 0.005,
      ),

      // Snacks & Extras
      Food(
        id: "dark_chocolate",
        name: "Dark Chocolate (70%)",
        category: "Snack",
        caloriesPerGram: 5.98,
        proteinPerGram: 0.08,
        carbsPerGram: 0.46,
        fatPerGram: 0.43,
      ),
      Food(
        id: "honey",
        name: "Honey",
        category: "Sweetener",
        caloriesPerGram: 3.04,
        proteinPerGram: 0.003,
        carbsPerGram: 0.82,
        fatPerGram: 0.0,
      ),
      Food(
        id: "protein_powder",
        name: "Whey Protein Powder",
        category: "Supplement",
        caloriesPerGram: 4.0,
        proteinPerGram: 0.80,
        carbsPerGram: 0.05,
        fatPerGram: 0.05,
      ),
    ];

    // Get unique categories
    final categories = foodList.map((f) => f.category).toSet().toList()..sort();

    // Filter foods based on search and category
    List<Food> filteredFoods =
        foodList.where((food) {
          final matchesSearch =
              _searchQuery.isEmpty ||
              food.name.toLowerCase().contains(_searchQuery.toLowerCase());
          final matchesCategory =
              _selectedCategory == null || food.category == _selectedCategory;
          return matchesSearch && matchesCategory;
        }).toList();

    // Group by category for display
    Map<String, List<Food>> groupedFoods = {};
    for (var food in filteredFoods) {
      groupedFoods.putIfAbsent(food.category, () => []).add(food);
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Add Food",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search foods...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                      suffixIcon:
                          _searchQuery.isNotEmpty
                              ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                              : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Category Filter Chips
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryChip('All', null),
                      ...categories.map((cat) => _buildCategoryChip(cat, cat)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Results Count
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '${filteredFoods.length} foods found',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Food List
          Expanded(
            child:
                filteredFoods.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount:
                          _selectedCategory != null
                              ? filteredFoods.length
                              : groupedFoods.keys.length,
                      itemBuilder: (context, index) {
                        if (_selectedCategory != null) {
                          // Show flat list when category is selected
                          return _buildFoodCard(filteredFoods[index]);
                        } else {
                          // Show grouped list
                          final category = groupedFoods.keys.toList()[index];
                          final foods = groupedFoods[category]!;
                          return _buildCategorySection(category, foods);
                        }
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String? category) {
    final isSelected = _selectedCategory == category;
    final color = category != null ? _getCategoryColor(category) : Colors.blue;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            _selectedCategory = category;
          });
        },
        backgroundColor: Colors.grey[200],
        selectedColor: color,
        checkmarkColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildCategorySection(String category, List<Food> foods) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _getCategoryColor(category).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getCategoryIcon(category),
                  size: 16,
                  color: _getCategoryColor(category),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                category,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${foods.length}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...foods.map((food) => _buildFoodCard(food)),
      ],
    );
  }

  Widget _buildFoodCard(Food food) {
    final color = _getCategoryColor(food.category);
    final calories = (food.caloriesPerGram * 100).toStringAsFixed(0);
    final protein = (food.proteinPerGram * 100).toStringAsFixed(1);
    final carbs = (food.carbsPerGram * 100).toStringAsFixed(1);
    final fat = (food.fatPerGram * 100).toStringAsFixed(1);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => Navigator.pop(context, food),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Category Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color.withOpacity(0.8), color],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getCategoryIcon(food.category),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // Food Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        food.category,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                      const SizedBox(height: 8),
                      // Macro pills
                      Row(
                        children: [
                          _buildMacroPill(
                            'P',
                            protein,
                            const Color(0xFFE91E63),
                          ),
                          const SizedBox(width: 6),
                          _buildMacroPill('C', carbs, const Color(0xFFFF9800)),
                          const SizedBox(width: 6),
                          _buildMacroPill('F', fat, const Color(0xFF2196F3)),
                        ],
                      ),
                    ],
                  ),
                ),

                // Calories
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      calories,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'kcal',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'per 100g',
                      style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                    ),
                  ],
                ),

                const SizedBox(width: 8),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMacroPill(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 3),
          Text(
            '${value}g',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(Icons.search_off, size: 40, color: Colors.grey[400]),
          ),
          const SizedBox(height: 16),
          Text(
            'No foods found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term or category',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
