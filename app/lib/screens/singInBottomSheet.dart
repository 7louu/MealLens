import 'package:flutter/material.dart';
import '../routes/routes.dart';
class SignInBottomSheet extends StatelessWidget {
  const SignInBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Image.asset('', height: 24),//don't forget to add the image
            title: const Text('Sign in with Google'),
            onTap: () {
              //TODO: link sign in with google from firebase to front 
            },
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: Image.asset('', height: 24),//don't forget to add the image
            title: const Text('Sign in with Email'),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }
}