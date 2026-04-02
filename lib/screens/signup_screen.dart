import 'package:ai_hairstyle_preview_app/services/auth_service.dart';
import 'package:ai_hairstyle_preview_app/models/user_model.dart';
import 'package:ai_hairstyle_preview_app/services/firestore_service.dart';
import 'package:ai_hairstyle_preview_app/utils/design_system.dart';
import 'package:ai_hairstyle_preview_app/widgets/custom_widgets.dart';
import 'package:ai_hairstyle_preview_app/screens/login_screen.dart'; // For FadeInUp
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final credential = await ref.read(authServiceProvider).signUp(
              _emailController.text.trim(),
              _passwordController.text.trim(),
            ).timeout(const Duration(seconds: 15));

        final user = UserModel(
          uid: credential.user!.uid,
          email: _emailController.text.trim(),
          displayName: _nameController.text.trim(),
        );

        await ref.read(firestoreServiceProvider).saveUser(user).timeout(const Duration(seconds: 10));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account Created! Please Login.')),
          );
          Navigator.pop(context); 
        }

      } on FirebaseAuthException catch (e) {
        String message = 'Signup Failed: ${e.message}';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signup Failed: ${e.toString()}')));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: DesignSystem.primaryGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: FadeInUp(
                child: StyleCard(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person_add_outlined, size: 48, color: DesignSystem.primaryGradientStart),
                        const SizedBox(height: 16),
                        Text(
                          'Create Account',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Join StyleAI today',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 40),
                        StyleTextField(
                          label: 'Full Name',
                          hint: 'Enter your name',
                          controller: _nameController,
                          prefixIcon: Icons.person_outline,
                          validator: (val) => val != null && val.isNotEmpty ? null : 'Name required',
                        ),
                        const SizedBox(height: 24),
                        StyleTextField(
                          label: 'Email',
                          hint: 'Enter your email',
                          controller: _emailController,
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) => val != null && val.contains('@') ? null : 'Enter valid email',
                        ),
                        const SizedBox(height: 24),
                        StyleTextField(
                          label: 'Password',
                          hint: 'Create a password',
                          controller: _passwordController,
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                          validator: (val) => val != null && val.length >= 6 ? null : 'Password too short (min 6 chars)',
                        ),
                        const SizedBox(height: 40),
                        StyleButton(
                          text: 'Sign Up',
                          onPressed: _signup,
                          isLoading: _isLoading,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account?"),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Login',
                                style: TextStyle(fontWeight: FontWeight.bold, color: DesignSystem.primaryGradientStart),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
