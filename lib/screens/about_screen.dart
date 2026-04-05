import 'package:ai_hairstyle_preview_app/utils/design_system.dart';
import 'package:ai_hairstyle_preview_app/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About StyleAI'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Icon with Shadow
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: DesignSystem.primaryGradientStart.withValues(alpha: 0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/images/app_icon.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.auto_awesome, size: 60, color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'StyleAI',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
              const Text(
                'Smart Hairstyle Preview',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 24),
              const StyleCard(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'StyleAI is an AI-powered mobile application that allows users to preview different hairstyles on their own photos using artificial intelligence.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, height: 1.6, letterSpacing: 0.2),
                ),
              ),
              const SizedBox(height: 32),
              _sectionTitle('Core Features'),
              const SizedBox(height: 16),
              _featuresList(),
              const SizedBox(height: 40),
              _infoRow('Version', '1.0.0'),
              _infoRow('Developer', 'Dhruv'),
              const SizedBox(height: 48),
              const Text(
                'AI Powered Hair Transformation',
                style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1),
              ),
              const SizedBox(height: 8),
              const Text(
                '© 2026 StyleAI. All rights reserved.',
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _featuresList() {
    final features = [
      'AI hairstyle preview',
      'Male & Female styles',
      'Image upload',
      'Notifications',
      'Data visualization',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.start,
      children: features
          .map((feature) => Chip(
                label: Text(feature, style: const TextStyle(fontSize: 12)),
                backgroundColor: DesignSystem.primaryGradientStart.withValues(alpha: 0.1),
                side: BorderSide.none,
                labelStyle: TextStyle(color: DesignSystem.primaryGradientStart),
              ))
          .toList(),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$label: ', style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
