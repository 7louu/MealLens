class UserModel {
  final String id;
  final String? name;
  final String email;
  final String role;
  final String photoUrl;
  final String gender;
  final String goal;
  final String? password;
  final int age;
  final int height; 
  final double weight; 
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.photoUrl,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.goal,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      name: data['name'],
      email: data['email'],
      password: data['password'],
      role: data['role'],
      photoUrl: data['photoUrl'],
      gender: data['gender'],
      age: data['age'],
      height: data['height'],
      weight: (data['weight'] as num).toDouble(),
      goal: data['goal'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'photoUrl': photoUrl,
      'gender': gender,
      'age': age,
      'height': height,
      'weight': weight,
      'goal' : goal,
    };
  }
}
