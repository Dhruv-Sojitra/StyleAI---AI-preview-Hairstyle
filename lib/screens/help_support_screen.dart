import 'package:ai_hairstyle_preview_app/utils/design_system.dart';
import 'package:ai_hairstyle_preview_app/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              DesignSystem.primaryGradientStart.withValues(alpha: 0.05),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Frequently Asked Questions'),
              const SizedBox(height: 16),
              _faqItem(
                'How to upload image?',
                'Navigate to the Home screen and tap the "Upload Photo" button. You can select an image from your gallery or take a new one with the camera.',
              ),
              _faqItem(
                'How to generate hairstyle preview?',
                'Once your photo is uploaded, choose a hairstyle from the list and tap the "Magic Happen" button. Our AI will process your image in seconds.',
              ),
              _faqItem(
                'Why is preview taking time?',
                'Processing high-quality AI transformations requires significant computing power. Depending on your internet speed and server load, it usually takes 10-15 seconds.',
              ),
              const SizedBox(height: 32),
              _sectionTitle('Contact Support'),
              const SizedBox(height: 16),
              StyleCard(
                child: Column(
                  children: [
                    _contactTile(
                      icon: Icons.email_outlined,
                      title: 'Email Support',
                      subtitle: 'support@styleai.com',
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _contactTile(
                      icon: Icons.message_outlined,
                      title: 'Send a Message',
                      subtitle: 'Directly from the app',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _faqItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: StyleCard(
        child: ExpansionTile(
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          title: Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: const TextStyle(color: Colors.grey, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: DesignSystem.primaryGradientStart.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: DesignSystem.primaryGradientStart),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
