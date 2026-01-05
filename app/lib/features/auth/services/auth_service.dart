import 'package:app/registration_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/services/user_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  User? get currentUser => firebaseAuth.currentUser;

  // Signs in or registers the user with Google.
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null; 

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
      final User user = userCredential.user!;

      final doc = await firestore.collection('users').doc(user.uid).get();

      // Return existing user model if found
      if (doc.exists) {
        return UserModel.fromMap(user.uid, doc.data()!);
      }

      // User signed in but has no profile yet -> Create one!
      final newUser = UserModel(
        id: user.uid,
        name: user.displayName ?? 'User',
        email: user.email ?? '',
        role: 'user',
        photoUrl: user.photoURL ?? '',
        gender: 'Not specified',
        age: 0,
        height: 0,
        weight: 0.0,
        goal: 'Not specified',
        activityLevel: 'Sedentary',
      );

      // Save to Firestore
      await firestore.collection('users').doc(user.uid).set(newUser.toMap());

      return newUser;

    } catch (e) {
      print("Google Sign-in failed: $e");
      return null;
    }
  }
  
  Future<UserModel?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User user = userCredential.user!;
      final doc = await firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        return UserModel.fromMap(user.uid, doc.data()!);
      }

      return null; // No profile found
    } catch (e) {
      print("Email sign-in failed: $e");
      return null;
    }
  }

  Future<UserModel?> registerWithEmail({
    required String? name,
    required String email,
    required String password,
    required RegistrationData data,
  }) async {
    try {
      final UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User user = userCredential.user!;
      final UserService userService = UserService();

      final userModel = UserModel(
        id: user.uid,
        name: name,
        email: email,
        role: 'user',
        photoUrl: '', 
        gender: data.gender ?? '',
        age: data.age ?? 0,
        height: data.height ?? 0,
        weight: data.weight ?? 0,
        goal: data.goal ?? '',
        activityLevel: data.activityLevel ?? 'Sedentary',
      );

      await userService.createOrUpdateUser(userModel);
      return userModel;
    } catch (e) {
      print("Email registration failed: $e");
      return null;
    }
  }

  Future<void> signOutEmail() async {
    await firebaseAuth.signOut();
  }
  
  Future<void> signOutGmail() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }
}
