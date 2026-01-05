//bottom sheet for sign in with existing account
import 'package:flutter/material.dart';
import '../../../routes/routes.dart';
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
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(child: CircularProgressIndicator()),
                );

                try {
                  final userModel = await AuthService().signInWithGoogle();
                  
                  // Close loading indicator
                  if (context.mounted) Navigator.pop(context);

                  if (userModel != null && context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.mainScreen, (route) => false);
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sign in failed or cancelled.')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context); // Close dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
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
