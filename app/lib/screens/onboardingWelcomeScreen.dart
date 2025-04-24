import 'package:flutter/material.dart';

class Onboardingwelcomescreen extends StatefulWidget {
  @override
  OnboardingWelcomeState createState() => OnboardingWelcomeState();
}

class OnboardingWelcomeState extends State<Onboardingwelcomescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Onboarding Welcome Screen'),
      ),
      body: Center(
        child: Text('Welcome to the Onboarding Screen!'),
      ),
    );
  }
}