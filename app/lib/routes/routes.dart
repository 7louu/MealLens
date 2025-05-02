import 'package:flutter/material.dart';
import '../screens/screens.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String onboarding = '/onboarding';
  static const String signIn = '/signIn';
  static const String login = '/login';
  static const String setup = '/setup';
  static const String goal = '/goal';
  static const String gender = '/gender';
  static const String activity = '/activity';
  static const String height = '/height';
  static const String weight = '/weight';
  static const String age = '/age';
  static const String register = '/register';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => SplashScreen(),
      welcome: (context) => const WelcomeScreen(),
      onboarding: (context) => const OnboardingScreen(),
      signIn: (context) => const SignInBottomSheet(),
      login: (context) => const LoginScreen(),
      goal: (context) => const GoalScreen(),
      gender: (context) => const GenderScreen(),
      activity: (context) => const ActivityScreen(),
      height: (context) => const HeightScreen(),
      weight: (context) => const WeightScreen(),
      age: (context) => const AgeScreen(),
      register: (context) => const RegisterScreen(),
    };
  }
}
