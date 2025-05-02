import 'package:app/screens/setupScreen.dart';
import 'package:flutter/material.dart';

class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});

  @override
  State<AgeScreen> createState() => AgeScreenState();
}

class AgeScreenState extends State<AgeScreen> {
  int age = 20;

  @override
  Widget build(BuildContext context) {
    return SetupScreen(
      title: "How old are you?",
      subtitle: "We need your age to calculate your calorie needs",
      content: Column(
        children: [
          Text(
            "$age years",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: age.toDouble(),
            min: 10,
            max: 100,
            divisions: 90,
            onChanged: (val) => setState(() => age = val.round()),
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
