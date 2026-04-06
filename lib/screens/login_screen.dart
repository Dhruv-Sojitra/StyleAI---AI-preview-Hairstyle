import 'package:ai_hairstyle_preview_app/screens/signup_screen.dart';
import 'package:ai_hairstyle_preview_app/services/auth_service.dart';
import 'package:ai_hairstyle_preview_app/utils/design_system.dart';
import 'package:ai_hairstyle_preview_app/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await ref
            .read(authServiceProvider)
            .signIn(
              _emailController.text.trim(),
              _passwordController.text.trim(),
            );
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided.';
        } else {
          message = 'Login Failed: ${e.message}';
        }
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login Failed: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: DesignSystem.primaryGradient),
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
                        const Icon(
                          Icons.auto_awesome,
                          size: 48,
                          color: DesignSystem.primaryGradientStart,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'StyleAI',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to continue',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 40),
                        StyleTextField(
                          label: 'Email',
                          hint: 'Enter your email',
                          controller: _emailController,
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) => val != null && val.contains('@')
                              ? null
                              : 'Enter valid email',
                        ),
                        const SizedBox(height: 24),
                        StyleTextField(
                          label: 'Password',
                          hint: 'Enter your password',
                          controller: _passwordController,
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                          validator: (val) => val != null && val.length >= 6
                              ? null
                              : 'Password too short',
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: DesignSystem.primaryGradientStart
                                    .withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        StyleButton(
                          text: 'Login',
                          onPressed: _login,
                          isLoading: _isLoading,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: DesignSystem.primaryGradientStart,
                                ),
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

class FadeInUp extends StatefulWidget {
  final Widget child;
  const FadeInUp({super.key, required this.child});

  @override
  State<FadeInUp> createState() => _FadeInUpState();
}

class _FadeInUpState extends State<FadeInUp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
