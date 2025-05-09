import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../registration_data.dart';

class UserService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Create or update the current user's document in Firestore.
  Future<void> createOrUpdateUser(UserModel userModel) async {
    await firestore.collection('users').doc(userModel.id).set(
      userModel.toMap(),
      SetOptions(merge: true),
    );
  }

  // Create user profile from google using registration data 
  Future<void> createUserProfileFromGoogle(User firebaseUser, RegistrationData data) async {
    final userModel = UserModel(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      role: 'user', 
      photoUrl: firebaseUser.photoURL ?? '',
      gender: data.gender ?? '',
      age: data.age ?? 0,
      height: data.height ?? 0,
      weight: data.weight ?? 0,
      goal: data.goal ?? '',
    );

    await createOrUpdateUser(userModel);
  }


  // Fetches the currently authenticated user's profile.
  Future<UserModel?> getCurrentUserProfile() async {
    final currentUser = auth.currentUser;
    if (currentUser == null) return null;

    final doc = await firestore.collection('users').doc(currentUser.uid).get();
    if (!doc.exists) return null;

    return UserModel.fromMap(doc.id, doc.data()!);
  }

  // Updates specific fields in the current user's profile.
  Future<void> updateUserFields(Map<String, dynamic> updatedFields) async {
    final currentUser = auth.currentUser;
    if (currentUser == null) throw Exception('No authenticated user.');

    await firestore.collection('users').doc(currentUser.uid).update(updatedFields);
  }

  // Deletes the current user's document from Firestore.
  Future<void> deleteUser() async {
    final currentUser = auth.currentUser;
    if (currentUser == null) throw Exception('No authenticated user.');

    await firestore.collection('users').doc(currentUser.uid).delete();
  }
}
