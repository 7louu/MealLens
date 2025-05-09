import 'package:flutter/material.dart';
import '../screens/screens.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';
  static const String signIn = '/signIn';
  static const String login = '/login';
  static const String goal = '/goal';
  static const String gender = '/gender';
  static const String activity = '/activity';
  static const String height = '/height';
  static const String weight = '/weight';
  static const String age = '/age';
  static const String register = '/register_google';
  static const String registerWithEmail = '/register_email';
  static const String diary = '/diary';
  static const String reports = '/report';
  static const String lens = '/lens';
  static const String mealEdit = '/meal_edit';
  static const String foodSearch = '/food_search';
  static const String mainScreen = '/main';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => SplashScreen(),
      onboarding: (context) => const OnboardingScreen(),
      welcome: (context) => const WelcomeScreen(),
      signIn: (context) => const SignInBottomSheet(),
      login: (context) => const LoginScreen(),
      goal: (context) => const GoalScreen(),
      gender: (context) => const GenderScreen(),
      activity: (context) => const ActivityScreen(),
      height: (context) => const HeightScreen(),
      weight: (context) => const WeightScreen(),
      age: (context) => const AgeScreen(),
      register: (context) => const RegisterBottomSheet(),
      registerWithEmail: (context) => const RegisterScreen(),
      diary: (context) => const DiaryScreen(),
      reports: (context) => ReportsScreen(),
      lens: (context) => const LensScreen(),
      mealEdit: (context) => const MealEditScreen(),
      foodSearch: (context) => const FoodSearchScreen(),
      mainScreen: (context) => const MainScreen(),
    };
  }
}
