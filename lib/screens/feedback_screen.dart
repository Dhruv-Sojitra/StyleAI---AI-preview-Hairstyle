import 'package:ai_hairstyle_preview_app/services/auth_service.dart';
import 'package:ai_hairstyle_preview_app/services/firestore_service.dart';
import 'package:ai_hairstyle_preview_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  final _controller = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (_controller.text.isEmpty) return;

    setState(() => _isLoading = true);
    final user = ref.read(authServiceProvider).currentUser;
    if (user != null) {
      await ref
          .read(firestoreServiceProvider)
          .submitFeedback(user.uid, _controller.text);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Feedback Sent!')));
        Navigator.pop(context);
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Tell us what you think...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Submit Feedback',
              onPressed: _submit,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
