import 'package:flutter/material.dart';
import '../models/food_model.dart';

class QuantitySelectionDialog extends StatefulWidget {
  final Food foodItem;

  const QuantitySelectionDialog({super.key, required this.foodItem});

  @override
  State<QuantitySelectionDialog> createState() => _QuantitySelectionDialogState();
}

class _QuantitySelectionDialogState extends State<QuantitySelectionDialog> {
  double _quantity = 100.0;

  @override
  Widget build(BuildContext context) {
    final calories = widget.foodItem.caloriesPerGram * _quantity;

    return AlertDialog(
      title: Text("Set quantity for ${widget.foodItem.name}"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("$_quantity grams"),
          Slider(
            value: _quantity,
            min: 10,
            max: 500,
            divisions: 49,
            label: "${_quantity.round()}g",
            onChanged: (value) {
              setState(() {
                _quantity = value;
              });
            },
          ),
          Text("≈ ${calories.toStringAsFixed(1)} kcal"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _quantity),
          child: const Text("Add"),
        ),
      ],
    );
  }
}
