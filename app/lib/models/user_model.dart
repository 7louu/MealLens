class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String photoUrl;
  final String gender;
  final int age;
  final double height; 
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
      height: (data['height'] as num).toDouble(),
      weight: (data['weight'] as num).toDouble(),
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
    };
  }
}
