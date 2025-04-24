import 'package:flutter/material.dart';
import 'screens/splashScreen.dart';
import 'screens/onboardingWelcomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MealLens',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // This sets the splash screen as the initial screen
    );
  }
}