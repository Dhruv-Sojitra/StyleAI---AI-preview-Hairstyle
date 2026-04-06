import 'package:ai_hairstyle_preview_app/screens/auth_wrapper.dart';
import 'package:ai_hairstyle_preview_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _finishOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthWrapper()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Spacer(),
            const Icon(
              Icons.face_retouching_natural,
              size: 120,
              color: Colors.purple,
            ),
            const SizedBox(height: 32),
            Text(
              'Discover Your New Look',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Try different hairstyles instantly using AI. Upload your photo and choose from hundreds of styles.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Spacer(),
            CustomButton(
              text: 'Get Started',
              onPressed: () => _finishOnboarding(context),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
