/// Application-wide constants for MealLens
class AppConstants {
  // Prevent instantiation
  AppConstants._();

  // ==================== NUTRITION ====================
  
  /// Calories per gram of protein
  static const double proteinCaloriesPerGram = 4.0;
  
  /// Calories per gram of carbohydrates
  static const double carbCaloriesPerGram = 4.0;
  
  /// Calories per gram of fat
  static const double fatCaloriesPerGram = 9.0;

  // ==================== DEFAULT GOALS ====================
  
  /// Default daily calorie goal (used if calculation fails)
  static const double defaultDailyCalories = 2000.0;
  
  /// Default daily protein goal in grams
  static const double defaultProteinGrams = 150.0;
  
  /// Default daily carbohydrate goal in grams
  static const double defaultCarbGrams = 250.0;
  
  /// Default daily fat goal in grams
  static const double defaultFatGrams = 65.0;

  // ==================== WATER TRACKING ====================
  
  /// Default daily water goal in liters
  static const double defaultWaterGoalLiters = 2.5;
  
  /// Water increment/decrement step in liters
  static const double waterStepLiters = 0.2;

  // ==================== ACTIVITY MULTIPLIERS ====================
  
  /// Harris-Benedict activity level multipliers
  static const Map<String, double> activityMultipliers = {
    'Sedentary': 1.2,
    'Low Active': 1.375,
    'Active': 1.55,
    'Very Active': 1.725,
  };

  // ==================== GOAL ADJUSTMENTS ====================
  
  /// Calorie deficit for weight loss goal (calories per day)
  static const double weightLossDeficit = 500.0;
  
  /// Calorie surplus for weight gain goal (calories per day)
  static const double weightGainSurplus = 500.0;

  // ==================== MACRONUTRIENT RATIOS ====================
  
  /// Protein target: grams per kg of body weight
  static const double proteinPerKgBodyWeight = 2.2;
  
  /// Fat percentage of total daily calories
  static const double fatCaloriePercentage = 0.25;

  // ==================== UI CONSTANTS ====================
  
  /// Default animation duration in milliseconds
  static const int defaultAnimationDuration = 300;
  
  /// Chart animation duration in milliseconds
  static const int chartAnimationDuration = 800;

  // ==================== VALIDATION ====================
  
  /// Minimum age for registration
  static const int minAge = 13;
  
  /// Maximum age for registration
  static const int maxAge = 120;
  
  /// Minimum height in cm
  static const double minHeight = 100.0;
  
  /// Maximum height in cm
  static const double maxHeight = 250.0;
  
  /// Minimum weight in kg
  static const double minWeight = 30.0;
  
  /// Maximum weight in kg
  static const double maxWeight = 300.0;
}
