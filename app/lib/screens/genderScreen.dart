import 'package:app/screens/setupScreen.dart';
import 'package:flutter/material.dart';
import '../routes/routes.dart';
class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => GenderScreenState();
}

class GenderScreenState extends State<GenderScreen> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return SetupScreen(
      title: "What's your gender?",
      subtitle: "Male bodies need more calories",
      content: Column(
        children: [
          genderOption("Male"),
          genderOption("Female"),
        ],
      ),
      onNext:() {
        Navigator.pushReplacementNamed(context, AppRoutes.activity);
      }, 
      onBack:() {
        Navigator.pushReplacementNamed(context, AppRoutes.goal);
      },
    );
  }

  Widget genderOption(String gender) {
    final isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() => selectedGender = gender),
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
            gender,
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
