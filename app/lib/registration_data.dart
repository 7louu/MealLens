import 'models/user_model.dart';

class RegistrationData {
  static final RegistrationData instance = RegistrationData.internal();
  factory RegistrationData() => instance;
  RegistrationData.internal();

  String? gender, activityLevel, name, email, photoUrl, role, goal, password;
  double? weight;
  int? age, height;

  void reset() {
    gender = null;
    activityLevel = null;
    height = null;
    weight = null;
    age = null;
    goal = null;
  }

  UserModel toUserModel(String uid) {
    return UserModel(
    id: uid,
    name: name ?? '',
    email: email ?? '',
    password: password ?? '',
    role: role ?? '',
    photoUrl: photoUrl ?? '',
    gender: gender ?? '',
    age: age ?? 0,
    height: height ?? 0,
    weight: weight ?? 0.0,
    goal: goal ?? '',
    );
  }
}