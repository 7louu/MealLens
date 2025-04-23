import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //instance of firebase auth to allow interactions with firebase authentication
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //instance of google sign in to let us integrate google sign in into the app
  final GoogleSignIn googleSignIn = GoogleSignIn();
  //the use of Future in here allows us to use async and await in the methods below
  //the "?" indicates that the return type can be either a user object or null so if the 
  //the sign in failed or the user cancelled the sign in the method will return null instead of a user object
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      //this part also checks if the user exists in firebase and if not it creates a new user in firebase
      final UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
      return userCredential.user;

    } catch (e) {
      print("Google Sign-in failed :$e");
      return null;
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }
  
  User? get currentUser => firebaseAuth.currentUser;
}