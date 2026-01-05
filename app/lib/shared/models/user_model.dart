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
    return UserModel(
      id: id,
      name: data['name'],
      email: data['email'],
      role: data['role'],
      photoUrl: data['photoUrl'],
      gender: data['gender'],
      age: data['age'],
      height: data['height'],
      weight: (data['weight'] as num).toDouble(),
      goal: data['goal'],
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
    // Calculate BMR (Basal Metabolic Rate)
    double bmr;
    if (gender.toLowerCase() == 'male') {
      // BMR for men: 88.362 + (13.397 × weight in kg) + (4.799 × height in cm) − (5.677 × age)
      bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      // BMR for women: 447.593 + (9.247 × weight in kg) + (3.098 × height in cm) − (4.330 × age)
      bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
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
    
    // Adjust for goal
    switch (goal.toLowerCase()) {
      case 'lose weight':
        return tdee - 500; // 500 calorie deficit for 0.5kg/week loss
      case 'gain weight':
        return tdee + 500; // 500 calorie surplus for 0.5kg/week gain
      case 'keep weight':
      default:
        return tdee; // Maintenance
    }
  }
  
  // Calculate protein goal (2.2g per kg body weight)
  double get proteinGoal => weight * 2.2;
  
  // Calculate fat goal (25% of daily calories)
  double get fatGoal => (dailyCalorieGoal * 0.25) / 9;
  
  // Calculate carbs goal (remaining calories after protein and fat)
  double get carbGoal {
    double proteinCalories = proteinGoal * 4;
    double fatCalories = fatGoal * 9;
    double remainingCalories = dailyCalorieGoal - proteinCalories - fatCalories;
    return remainingCalories / 4;
  }
}
