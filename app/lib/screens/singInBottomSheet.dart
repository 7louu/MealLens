import 'package:flutter/material.dart';
import '../routes/routes.dart';

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
              onTap: () {
                // TODO: link sign in with google from firebase to front
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
