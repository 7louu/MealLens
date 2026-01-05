//in flutter you can't import an entire folder directly you can either import each file 
//or create a barrel file that exports everything from that folder
//we used it here to give the routes.dart file access to all the screens

// ==================== AUTH ====================
export '../features/auth/screens/welcome_screen.dart';
export '../features/auth/screens/sign_in_bottom_sheet.dart';
export '../features/auth/screens/login_screen.dart';
export '../features/auth/screens/register_bottom_sheet.dart';
export '../features/auth/screens/register_screen.dart';

// ==================== ONBOARDING ====================
export '../features/onboarding/screens/splash_screen.dart';
export '../features/onboarding/screens/onboarding_screen.dart';
export '../features/onboarding/screens/goal_screen.dart';
export '../features/onboarding/screens/gender_screen.dart';
export '../features/onboarding/screens/activity_screen.dart';
export '../features/onboarding/screens/height_screen.dart';
export '../features/onboarding/screens/weight_screen.dart';
export '../features/onboarding/screens/age_screen.dart';

// ==================== DIARY ====================
export '../features/diary/screens/main_screen.dart';
export '../features/diary/screens/diary_screen.dart';
export '../features/diary/screens/meal_edit_screen.dart';

// ==================== LENS ====================
export '../features/lens/screens/lens_screen.dart';

// ==================== REPORTS ====================
export '../features/reports/screens/report_screen.dart';

// ==================== FOOD ====================
export '../features/food/screens/food_search_screen.dart';
