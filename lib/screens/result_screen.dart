import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ai_hairstyle_preview_app/models/generation_result_model.dart';
import 'package:ai_hairstyle_preview_app/models/hairstyle_model.dart';
import 'package:ai_hairstyle_preview_app/services/auth_service.dart';
import 'package:ai_hairstyle_preview_app/services/firestore_service.dart';
import 'package:ai_hairstyle_preview_app/utils/design_system.dart';
import 'package:ai_hairstyle_preview_app/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

class ResultScreen extends ConsumerStatefulWidget {
  final File originalImage;
  final String? originalImageUrl;
  final String generatedImageUrl;
  final HairstyleModel hairstyle;
  final bool isDemoMode;

  const ResultScreen({
    super.key,
    required this.originalImage,
    this.originalImageUrl,
    required this.generatedImageUrl,
    required this.hairstyle,
    this.isDemoMode = false,
  });

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> with SingleTickerProviderStateMixin {
  bool _savedToHistory = false;
  bool _showOriginal = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _saveToHistory();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _saveToHistory() async {
    if (_savedToHistory) return;

    try {
      final user = ref.read(authServiceProvider).currentUser;
      if (user == null) return;

      final firestore = ref.read(firestoreServiceProvider);

      final result = GenerationResult(
        id: const Uuid().v4(),
        userId: user.uid,
        originalImageUrl: widget.originalImageUrl ?? '',
        generatedImageUrl: widget.generatedImageUrl,
        hairstyleName: widget.hairstyle.name,
        timestamp: DateTime.now(),
      );

      await firestore.saveGenerationResult(result);
      setState(() => _savedToHistory = true);
    } catch (e) {
      debugPrint('Failed to save to history: $e');
    }
  }

  Future<void> _downloadImage() async {
    try {
      final response = await http.get(Uri.parse(widget.generatedImageUrl));
      if (response.statusCode == 200) {
        await Gal.putImageBytes(response.bodyBytes);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Saved to Gallery ✨'), backgroundColor: Colors.green),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Download failed'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  Future<void> _shareImage() async {
    try {
      final response = await http.get(Uri.parse(widget.generatedImageUrl));
      if (response.statusCode == 200) {
        final tempDir = Directory.systemTemp;
        final file = File('${tempDir.path}/styleai_${DateTime.now().millisecondsSinceEpoch}.png');
        await file.writeAsBytes(response.bodyBytes);
        await Share.shareXFiles([XFile(file.path)], text: 'Rate my new look from StyleAI!');
      }
    } catch (e) {
      debugPrint('Error sharing: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            onPressed: _shareImage,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Background Generated Image
          Positioned.fill(
            child: Container(
              color: Colors.black,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _showOriginal 
                  ? Image.file(widget.originalImage, key: const ValueKey('orig'), fit: BoxFit.cover)
                  : CachedNetworkImage(
                      key: const ValueKey('gen'),
                      imageUrl: widget.generatedImageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.white)),
                    ),
              ),
            ),
          ),

          // Compare Toggle Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 60,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTapDown: (_) => setState(() => _showOriginal = true),
                onTapUp: (_) => setState(() => _showOriginal = false),
                onTapCancel: () => setState(() => _showOriginal = false),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.compare_arrows, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        _showOriginal ? 'Release to see New' : 'Hold to see Before',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Demo Mode Banner
          if (widget.isDemoMode)
            Positioned(
              top: MediaQuery.of(context).padding.top + 110,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline_rounded, color: Colors.white, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Preview generated (demo mode)',
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Bottom Info & Actions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.95),
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: DesignSystem.primaryGradientStart.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: DesignSystem.primaryGradientStart.withValues(alpha: 0.5)),
                      ),
                      child: Text(
                        widget.hairstyle.name.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Looks amazing on you! ✨',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: StyleButton(
                            text: 'Save to Gallery',
                            icon: Icons.download_done_rounded,
                            onPressed: _downloadImage,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                      child: Text(
                        'Back to Styles',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
