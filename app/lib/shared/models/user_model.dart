class UserModel {
  final String id;
  final String? name;
  final String email;
  final String role;
  final String photoUrl;
  final String gender;
  final String goal;
  final String activityLevel;
  final int age;
  final int height; 
  final double weight; 
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.photoUrl,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.goal,
    required this.activityLevel,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    // Handle height - could be stored in cm (correct) or meters (incorrect)
    int rawHeight = data['height'] ?? 170;
    // If height is less than 10, assume it's in meters and convert to cm
    // If between 10-100, it's ambiguous - use default
    // If >= 100, assume it's already in cm
    int height;
    if (rawHeight < 10) {
      // Likely stored as meters (e.g., 1.9 stored as 1 or 2)
      height = 170; // Use default - can't reliably convert
    } else if (rawHeight < 100) {
      // Ambiguous - could be short height in cm or wrong unit
      height = 170; // Use default
    } else {
      height = rawHeight;
    }
    
    // Handle weight - ensure it's valid
    double rawWeight = (data['weight'] as num?)?.toDouble() ?? 70.0;
    double weight = rawWeight > 0 && rawWeight < 500 ? rawWeight : 70.0;
    
    // Handle age - ensure it's valid
    int rawAge = data['age'] ?? 25;
    int age = rawAge > 0 && rawAge < 120 ? rawAge : 25;
    
    return UserModel(
      id: id,
      name: data['name'] ?? 'User',
      email: data['email'] ?? '',
      role: data['role'] ?? 'user',
      photoUrl: data['photoUrl'] ?? '',
      gender: data['gender'] ?? 'male',
      age: age,
      height: height,
      weight: weight,
      goal: data['goal'] ?? 'keep weight',
      activityLevel: data['activityLevel'] ?? 'Sedentary',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'photoUrl': photoUrl,
      'gender': gender,
      'age': age,
      'height': height,
      'weight': weight,
      'goal': goal,
      'activityLevel': activityLevel,
    };
  }
  
  // Calculate daily calorie goal using Harris-Benedict Equation
  double get dailyCalorieGoal {
    // Validate inputs - use defaults if invalid
    final validWeight = weight > 0 ? weight : 70.0;
    final validHeight = height > 0 ? height : 170;
    final validAge = age > 0 ? age : 25;
    
    // Calculate BMR (Basal Metabolic Rate)
    double bmr;
    if (gender.toLowerCase() == 'male') {
      // BMR for men: 88.362 + (13.397 × weight in kg) + (4.799 × height in cm) − (5.677 × age)
      bmr = 88.362 + (13.397 * validWeight) + (4.799 * validHeight) - (5.677 * validAge);
    } else {
      // BMR for women: 447.593 + (9.247 × weight in kg) + (3.098 × height in cm) − (4.330 × age)
      bmr = 447.593 + (9.247 * validWeight) + (3.098 * validHeight) - (4.330 * validAge);
    }
    
    // Activity level multiplier
    double activityMultiplier;
    switch (activityLevel.toLowerCase()) {
      case 'sedentary':
        activityMultiplier = 1.2;
        break;
      case 'low active':
        activityMultiplier = 1.375;
        break;
      case 'active':
        activityMultiplier = 1.55;
        break;
      case 'very active':
        activityMultiplier = 1.725;
        break;
      default:
        activityMultiplier = 1.2;
    }
    
    // TDEE (Total Daily Energy Expenditure)
    double tdee = bmr * activityMultiplier;
    
    // Ensure minimum reasonable calorie goal
    tdee = tdee.clamp(1200.0, 5000.0);
    
    // Adjust for goal
    switch (goal.toLowerCase()) {
      case 'lose weight':
        return (tdee - 500).clamp(1200.0, 5000.0); // 500 calorie deficit
      case 'gain weight':
        return (tdee + 500).clamp(1200.0, 5000.0); // 500 calorie surplus
      case 'keep weight':
      default:
        return tdee; // Maintenance
    }
  }
  
  // Calculate protein goal using percentage of calories (25-30% of calories)
  // Standard recommendation: 1.6-2.2g per kg for active individuals
  // Using 1.8g per kg as a balanced default
  double get proteinGoal {
    final validWeight = weight > 0 ? weight : 70.0;
    // 1.8g per kg body weight - good for moderately active individuals
    final byWeight = validWeight * 1.8;
    // Ensure reasonable range (minimum 50g, maximum 250g)
    return byWeight.clamp(50.0, 250.0);
  }
  
  // Calculate fat goal (25-30% of daily calories)
  // Fat has 9 calories per gram
  double get fatGoal {
    // 28% of calories from fat (middle of healthy range)
    final fatCalories = dailyCalorieGoal * 0.28;
    final fatGrams = fatCalories / 9;
    // Ensure reasonable range (minimum 40g, maximum 150g)
    return fatGrams.clamp(40.0, 150.0);
  }
  
  // Calculate carbs goal (remaining calories after protein and fat)
  // Carbs have 4 calories per gram
  double get carbGoal {
    final proteinCalories = proteinGoal * 4;
    final fatCalories = fatGoal * 9;
    final remainingCalories = dailyCalorieGoal - proteinCalories - fatCalories;
    // Carbs = remaining calories / 4 cal per gram
    final carbGrams = remainingCalories / 4;
    // Ensure reasonable range (minimum 100g, maximum 400g)
    return carbGrams.clamp(100.0, 400.0);
  }
}
