import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload a profile picture and return the download URL
  Future<String?> uploadProfilePicture(File imageFile) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final ref = _storage.ref().child('profile_pictures/${user.uid}.jpg');
      
      final uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      print('Error uploading profile picture: $e');
      return null;
    }
  }

  /// Delete the current user's profile picture
  Future<bool> deleteProfilePicture() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      final ref = _storage.ref().child('profile_pictures/${user.uid}.jpg');
      await ref.delete();
      return true;
    } catch (e) {
      print('Error deleting profile picture: $e');
      return false;
    }
  }
}
