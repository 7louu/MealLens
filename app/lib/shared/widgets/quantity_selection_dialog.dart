import 'package:flutter/material.dart';
import '../models/food_model.dart';

class QuantitySelectionDialog extends StatefulWidget {
  final Food foodItem;

  const QuantitySelectionDialog({super.key, required this.foodItem});

  @override
  State<QuantitySelectionDialog> createState() =>
      _QuantitySelectionDialogState();

  // Category styling
  static const Map<String, IconData> categoryIcons = {
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

  static const Map<String, Color> categoryColors = {
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
}

class _QuantitySelectionDialogState extends State<QuantitySelectionDialog> {
  double _quantity = 100.0;
  final TextEditingController _controller = TextEditingController(text: '100');

  IconData get _categoryIcon =>
      QuantitySelectionDialog.categoryIcons[widget.foodItem.category] ??
      Icons.restaurant;

  Color get _categoryColor =>
      QuantitySelectionDialog.categoryColors[widget.foodItem.category] ??
      Colors.grey;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setQuantity(double value) {
    setState(() {
      _quantity = value.clamp(1, 1000);
      _controller.text = _quantity.round().toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final calories = widget.foodItem.caloriesPerGram * _quantity;
    final protein = widget.foodItem.proteinPerGram * _quantity;
    final carbs = widget.foodItem.carbsPerGram * _quantity;
    final fat = widget.foodItem.fatPerGram * _quantity;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with food info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_categoryColor.withOpacity(0.8), _categoryColor],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(_categoryIcon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.foodItem.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.foodItem.category,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Quantity input section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Quantity display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: _categoryColor,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (value) {
                            final parsed = double.tryParse(value);
                            if (parsed != null) {
                              setState(() {
                                _quantity = parsed.clamp(1, 1000);
                              });
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'g',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Quick select buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildQuickButton(50),
                      _buildQuickButton(100),
                      _buildQuickButton(150),
                      _buildQuickButton(200),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Slider
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: _categoryColor,
                      inactiveTrackColor: _categoryColor.withOpacity(0.2),
                      thumbColor: _categoryColor,
                      overlayColor: _categoryColor.withOpacity(0.1),
                      trackHeight: 8,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 14,
                      ),
                    ),
                    child: Slider(
                      value: _quantity.clamp(10, 500),
                      min: 10,
                      max: 500,
                      divisions: 49,
                      onChanged: _setQuantity,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '10g',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                      Text(
                        '500g',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Nutrition preview
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        // Calories row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              color: Colors.orange[700],
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              calories.toStringAsFixed(0),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'kcal',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Macros row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMacroDisplay(
                              'Protein',
                              protein,
                              const Color(0xFFE91E63),
                            ),
                            _buildMacroDisplay(
                              'Carbs',
                              carbs,
                              const Color(0xFFFF9800),
                            ),
                            _buildMacroDisplay(
                              'Fat',
                              fat,
                              const Color(0xFF2196F3),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, _quantity),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _categoryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Add to Meal',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickButton(int grams) {
    final isSelected = _quantity.round() == grams;

    return GestureDetector(
      onTap: () => _setQuantity(grams.toDouble()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _categoryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${grams}g',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroDisplay(String label, double value, Color color) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.toStringAsFixed(1)}g',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      ],
    );
  }
}
