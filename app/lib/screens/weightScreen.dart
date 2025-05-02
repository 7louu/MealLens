import 'package:app/screens/setupScreen.dart';
import 'package:flutter/material.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => WeightScreenState();
}

class WeightScreenState extends State<WeightScreen> {
  int weight = 70;

  @override
  Widget build(BuildContext context) {
    return SetupScreen(
      title: "What’s your weight?",
      subtitle: "We'll use this to estimate calories and nutrition",
      content: Column(
        children: [
          Text(
            "$weight kg",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: weight.toDouble(),
            min: 30,
            max: 200,
            divisions: 170,
            onChanged: (val) => setState(() => weight = val.round()),
            activeColor: Colors.black,
            inactiveColor: Colors.black26,
          ),
        ],
      ),
      //onNext: ,
      //onBack: ,
    );
  }
}
