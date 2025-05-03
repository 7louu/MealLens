import 'package:app/screens/setupScreen.dart';
import 'package:flutter/material.dart';
import '../routes/routes.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => ActivityScreenState();
}

class ActivityScreenState extends State<ActivityScreen> {
  String? selectedLevel;

  @override
  Widget build(BuildContext context) {
    return SetupScreen(
      title: "How active are you?",
      subtitle: "A sedentary person burns fewer calories than an active person",
      content: Column(
        children: [
          activityOption("Sedentary"),
          activityOption("Low Active"),
          activityOption("Active"),
          activityOption("Very Active"),
        ],
      ),
      onNext:() {
        Navigator.pushReplacementNamed(context, AppRoutes.height);
      },
      onBack:() {
        Navigator.pushReplacementNamed(context, AppRoutes.gender);
      },
    );
  }

  Widget activityOption(String level) {
    final isSelected = selectedLevel == level;
    return GestureDetector(
      onTap: () => setState(() => selectedLevel = level),
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
            level,
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
