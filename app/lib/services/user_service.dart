import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// A service class to handle all CRUD operations for the `users` collection in Firestore.
/// Each user is stored as a document whose ID is the Firebase Auth UID.
class UserService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// Creates or updates the user document in 'users' collection.
  /// Uses Firebase Auth UID as the document ID.
  Future<void> createOrUpdateUser({
    required String name,
    required String role, // 'user' or 'admin'
    required String photoUrl,
  }) async {
    final user = auth.currentUser;
    if (user == null) throw Exception('No authenticated user.');

    await firestore.collection('users').doc(user.uid).set({
      'name': name,
      'email': user.email,
      'role': role,
      'photoUrl': photoUrl,
    }, SetOptions(merge: true));
  }

  /// Retrieves current user's profile data as a map or null if not exists.
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final user = auth.currentUser;
    if (user == null) return null;

    final snap = await firestore.collection('users').doc(user.uid).get();
    return snap.exists ? snap.data() : null;
  }

  /// Updates specified fields in the user document.
  /// Pass a map of field names and values to update.
  Future<void> updateUser({
    required Map<String, dynamic> updatedData,
  }) async {
    final user = auth.currentUser;
    if (user == null) throw Exception('No authenticated user.');

    await firestore.collection('users').doc(user.uid).update(updatedData);
  }

  /// Deletes the current user's document.
  Future<void> deleteUser() async {
    final user = auth.currentUser;
    if (user == null) throw Exception('No authenticated user.');

    await firestore.collection('users').doc(user.uid).delete();
  }
}
