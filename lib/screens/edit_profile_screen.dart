import 'package:ai_hairstyle_preview_app/services/auth_service.dart';
import 'package:ai_hairstyle_preview_app/utils/design_system.dart';
import 'package:ai_hairstyle_preview_app/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authServiceProvider).currentUser;
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) return;
    
    setState(() => _isLoading = true);
    try {
      await ref.read(authServiceProvider).updateProfile(
        displayName: _nameController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully! ✨'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(shape: BoxShape.circle, gradient: DesignSystem.primaryGradient),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person_outline_rounded, size: 40, color: DesignSystem.primaryGradientStart),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: DesignSystem.softShadow),
                  child: const Icon(Icons.camera_alt_rounded, size: 20, color: DesignSystem.primaryGradientStart),
                ),
              ],
            ),
            const SizedBox(height: 32),
            StyleTextField(
              label: 'Display Name',
              hint: 'Enter your name',
              controller: _nameController,
              prefixIcon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 20),
            StyleTextField(
              label: 'Email Address',
              hint: 'yourname@example.com',
              controller: _emailController,
              prefixIcon: Icons.email_outlined,
              // Email is usually read-only unless you implement verification flow
            ),
            const SizedBox(height: 48),
            StyleButton(
              text: 'Save Changes',
              onPressed: _saveProfile,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
