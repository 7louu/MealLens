import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../routes/routes.dart';
import '../../../registration_data.dart';
import '../services/auth_service.dart';
import '../../../shared/services/user_service.dart';
import '../../../shared/services/storage_service.dart';
import '../../../shared/models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  File? profileImage;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => profileImage = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black,),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.age);
          },
        ),
        title: const Text('Register', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: profileImage != null
                        ? FileImage(profileImage!)
                        : AssetImage('assets/images/default_avatar.png') as ImageProvider,
                    backgroundColor: Colors.grey[200],
                  ),
                  Positioned(
                    child: InkWell(
                      onTap: pickImage,
                      child: const CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 18,
                        child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 50),
              TextFormField(
                controller: nameController,
                validator: (value) =>
                  value == null || value.isEmpty? 'Please enter your user name' : null,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline),
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                validator: (value) =>
                  value == null || value.isEmpty? 'Please enter your email' : null,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                validator: (value) => 
                  value == null || value.isEmpty? 'Please enter your password' : null,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => obscurePassword = !obscurePassword);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 250),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        // Save data to RegistrationData singleton
                        RegistrationData.instance.name = nameController.text.trim();
                        RegistrationData.instance.email = emailController.text.trim();

                        // Show loading spinner
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(child: CircularProgressIndicator()),
                        );

                        try {
                          final authService = AuthService();
                          final userService = UserService();
                          final storageService = StorageService();

                          // Step 1: Create account in Firebase Auth
                          final user = await authService.registerWithEmail(
                            name: RegistrationData.instance.name,
                            email: RegistrationData.instance.email!,
                            password: passwordController.text.trim(),
                            data: RegistrationData.instance
                          );

                          if (user == null) {
                            Navigator.pop(context); // Remove loading
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Registration failed.')),
                            );
                            return;
                          }

                          // Step 2: Upload profile picture if selected
                          String? photoUrl;
                          if (profileImage != null) {
                            photoUrl = await storageService.uploadProfilePicture(profileImage!);
                          }

                          // Step 3: Build UserModel
                          final userModel = UserModel(
                            id: user.id,
                            name: RegistrationData.instance.name!,
                            email: RegistrationData.instance.email!,
                            role: 'user',
                            photoUrl: photoUrl ?? '',
                            gender: RegistrationData.instance.gender ?? '',
                            age: RegistrationData.instance.age ?? 0,
                            height: RegistrationData.instance.height ?? 0,
                            weight: RegistrationData.instance.weight ?? 0,
                            goal: RegistrationData.instance.goal ?? '',
                            activityLevel: RegistrationData.instance.activityLevel ?? 'Sedentary',
                          );

                          // Step 4: Save to Firestore
                          await userService.createOrUpdateUser(userModel);

                          Navigator.pop(context); // Remove loading

                          // Step 5: Navigate to main screen
                          Navigator.pushReplacementNamed(context, AppRoutes.mainScreen);

                        } catch (e) {
                          Navigator.pop(context); // Remove loading
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('An error occurred: $e')),
                          );
                        }
                      }
                    },
                  child: Text('Register', style: TextStyle(fontSize: 16, color: Colors.white,)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
