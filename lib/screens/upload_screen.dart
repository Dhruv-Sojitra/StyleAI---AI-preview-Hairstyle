import 'dart:io';
import 'package:ai_hairstyle_preview_app/models/hairstyle_model.dart';
import 'package:ai_hairstyle_preview_app/services/auth_service.dart';
import 'package:ai_hairstyle_preview_app/services/cloudinary_service.dart';
import 'package:ai_hairstyle_preview_app/screens/result_screen.dart';
import 'package:ai_hairstyle_preview_app/services/free_ai_service.dart';
import 'package:ai_hairstyle_preview_app/utils/design_system.dart';
import 'package:ai_hairstyle_preview_app/widgets/custom_widgets.dart';
import 'package:ai_hairstyle_preview_app/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class UploadScreen extends ConsumerStatefulWidget {
  final HairstyleModel selectedHairstyle;

  const UploadScreen({super.key, required this.selectedHairstyle});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isGenerating = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() => _imageFile = File(pickedFile.path));
        await NotificationService().scheduleReminder();
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<void> _generate() async {
    if (_imageFile == null) return;
    setState(() => _isGenerating = true);

    try {
      final auth = ref.read(authServiceProvider);
      final user = auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      final cloudinaryService = ref.read(cloudinaryServiceProvider);
      final freeAiService = ref.read(freeAiServiceProvider);

      final String originalUrl = await cloudinaryService.uploadToCloudinary(
        _imageFile!,
      );

      String? generatedUrl;
      bool isDemoMode = false;

      try {
        final generatedBytes = await freeAiService.generateHairstyleImage(
          imageBytes: await _imageFile!.readAsBytes(),
          hairstyle: widget.selectedHairstyle.name,
        );
        generatedUrl = await cloudinaryService.uploadToCloudinary(
          generatedBytes,
        );
      } catch (e) {
        debugPrint(
          '⚠️ [Generation] HuggingFace failed, entering Demo Mode: $e',
        );
        generatedUrl = originalUrl;
        isDemoMode = true;
      }

      await NotificationService().cancelReminder();
      await NotificationService().showInstantNotification();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              originalImage: _imageFile!,
              originalImageUrl: originalUrl,
              generatedImageUrl: generatedUrl!,
              hairstyle: widget.selectedHairstyle,
              isDemoMode: isDemoMode,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Generation Failed: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Choose Source',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: _buildSourceItem(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildSourceItem(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return StyleCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(icon, size: 32, color: DesignSystem.primaryGradientStart),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text('Upload Photo'),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: theme.colorScheme.onSurface,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
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
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    StyleCard(
                      color: DesignSystem.primaryGradientStart.withValues(
                        alpha: 0.05,
                      ),
                      boxShadow: [],
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lightbulb_outline,
                            color: DesignSystem.primaryGradientStart,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Tip: Ensure good lighting and face the camera directly for the best AI result.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    GestureDetector(
                      onTap: _showImageSourceSheet,
                      child: Container(
                        height: 380,
                        decoration: BoxDecoration(
                          color: theme.cardTheme.color,
                          borderRadius: DesignSystem.outerBorderRadius,
                          boxShadow: DesignSystem.softShadow,
                          border: Border.all(
                            color: DesignSystem.primaryGradientStart.withValues(
                              alpha: 0.1,
                            ),
                            width: 2,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _imageFile != null
                            ? Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.file(_imageFile!, fit: BoxFit.cover),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withValues(alpha: 0.5),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 24,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.sync,
                                              size: 18,
                                              color: DesignSystem
                                                  .primaryGradientStart,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Change Photo',
                                              style: TextStyle(
                                                color: DesignSystem
                                                    .primaryGradientStart,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: DesignSystem.primaryGradientStart
                                          .withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.add_a_photo_outlined,
                                      size: 48,
                                      color: DesignSystem.primaryGradientStart,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'Tap to Take/Upload Photo',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'High quality portraits work best',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Text(
                      'Transforming to:',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    StyleCard(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              widget.selectedHairstyle.imagePath,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.selectedHairstyle.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: DesignSystem.primaryGradientStart
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    widget.selectedHairstyle.gender,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: DesignSystem.primaryGradientStart,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.auto_awesome,
                            color: DesignSystem.primaryGradientStart,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                    StyleButton(
                      text: 'Magic Happen ✨',
                      onPressed: _generate,
                      isLoading: _isGenerating,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isGenerating)
          const LoadingOverlay(message: 'Our AI is crafting your new look...'),
      ],
    );
  }
}
