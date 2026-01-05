//bottom sheet for sign in with existing account
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../routes/routes.dart';
import '../services/auth_service.dart';
import '../../../shared/services/user_service.dart';
import '../../../registration_data.dart';

class RegisterBottomSheet extends StatelessWidget {
  const RegisterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Image.asset('assets/images/google_sign_in.png', height: 24),
              title: const Text('Continue with Google'),
              onTap: () async {
                final authService = AuthService();
                final userService = UserService();

                // Step 1: Sign in with Google
                final firebaseUser = await authService.signInWithGoogle();
                if (firebaseUser == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Google sign-in failed")),
                  );
                  return;
                }

                // Step 2: Check if user already exists
                final doc = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(firebaseUser.id)
                    .get();

                // Step 3: If not, create a user with RegistrationData
                if (!doc.exists) {
                  await userService.createUserProfileFromGoogle(
                    firebaseUser as User,
                    RegistrationData.instance,
                  );
                }

                // Step 4: Navigate to the main screen
                Navigator.pushReplacementNamed(context, AppRoutes.mainScreen);
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: Image.asset('assets/images/email_sign_in.jpg', height: 24),
              title: const Text('Continue with Email'),
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRoutes.registerWithEmail);
              },
            ),
          ],
        ),
      ),
    );
  }
}
