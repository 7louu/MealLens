import 'package:app/screens/setupScreen.dart';
import 'package:flutter/material.dart';
import '../routes/routes.dart';
class HeightScreen extends StatefulWidget {
  const HeightScreen({super.key});

  @override
  State<HeightScreen> createState() => HeightScreenState();
}

class HeightScreenState extends State<HeightScreen> {
  int selectedMeters = 1;
  int selectedCentimeters = 70;

  @override
  Widget build(BuildContext context) {
    return SetupScreen(
      title: "How tall are you?",
      subtitle: "The taller you are, the more calories your body needs",
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          numberPicker(
            value: selectedMeters,
            min: 1,
            max: 2,
            onChanged: (val) => setState(() => selectedMeters = val),
            unit: "m",
          ),
          SizedBox(width: 16),
          numberPicker(
            value: selectedCentimeters,
            min: 0,
            max: 99,
            onChanged: (val) => setState(() => selectedCentimeters = val),
            unit: "cm",
          ),
        ],
      ),
      onNext:() {
        Navigator.pushReplacementNamed(context, AppRoutes.weight);
      },
      onBack:() {
        Navigator.pushReplacementNamed(context, AppRoutes.activity);
      },
    );
  }

  Widget numberPicker({
    required int value,
    required int min,
    required int max,
    required ValueChanged<int> onChanged,
    required String unit,
  }) {
    return Column(
      children: [
        Text(
          "$value",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        Text(unit),
        Slider(
          value: value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          onChanged: (double newVal) {
            onChanged(newVal.round());
          },
          activeColor: Colors.black,
          inactiveColor: Colors.black26,
        ),
      ],
    );
  }
}
