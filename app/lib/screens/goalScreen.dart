import 'package:app/screens/setupScreen.dart';
import 'package:flutter/material.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => GoalScreenState();
}

class GoalScreenState extends State<GoalScreen> {
  String? selectedGoal;

  @override
  Widget build(BuildContext context) {
    return SetupScreen(
      title: "What's your goal?",
      subtitle: "We will calculate daily calories according to your goal",
      content: Column(
        children: [
          goalOption("Lose weight"),
          goalOption("Keep weight"),
          goalOption("Gain weight"),
        ],
      ),
      //onNext : Implement Navigation to gender screen
    );
  }

  Widget goalOption(String text) {
    final isSelected = selectedGoal == text;
    return GestureDetector(
      onTap: () => setState(() => selectedGoal = text),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.black : Colors.transparent,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}