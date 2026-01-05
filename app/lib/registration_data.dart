import 'shared/models/user_model.dart';

class RegistrationData {
  static final RegistrationData instance = RegistrationData.internal();
  factory RegistrationData() => instance;
  RegistrationData.internal();

  String? gender, activityLevel, name, email, photoUrl, role, goal;
  double? weight;
  int? age, height;

  void reset() {
    gender = null;
    activityLevel = null;
    height = null;
    weight = null;
    age = null;
    goal = null;
    name = null;
    email = null;
    photoUrl = null;
    role = null;
  }

  UserModel toUserModel(String uid) {
    return UserModel(
      id: uid,
      name: name ?? '',
      email: email ?? '',
      role: role ?? 'user',
      photoUrl: photoUrl ?? '',
      gender: gender ?? '',
      age: age ?? 0,
      height: height ?? 0,
      weight: weight ?? 0.0,
      goal: goal ?? '',
      activityLevel: activityLevel ?? 'Sedentary',
    );
  }
}