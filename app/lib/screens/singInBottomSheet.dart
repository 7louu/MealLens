//bottom sheet for sign in with existing account
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../routes/routes.dart';
import '../services/auth_service.dart';
class SignInBottomSheet extends StatelessWidget {
  const SignInBottomSheet({super.key});

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
              title: const Text('Sign in with Google'),
              onTap: () async {
                final userModel = await AuthService().signInWithGoogle();

                if (userModel != null) {
                  Navigator.pushReplacementNamed(context, AppRoutes.mainScreen);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No account found. Please register first')),
                  );
                }
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: Image.asset('assets/images/email_sign_in.jpg', height: 24),
              title: const Text('Sign in with Email'),
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
