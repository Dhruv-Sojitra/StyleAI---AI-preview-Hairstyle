import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final replicateServiceProvider = Provider<ReplicateService>((ref) => ReplicateService());

class ReplicateService {
  // Toggle for Mock Generation
  static const bool _useMock = true; 
  
  // Replace with actual API key
  static const String _replicateApiToken = 'YOUR_REPLICATE_API_TOKEN'; // Replace with your token from https://replicate.com/account/api-tokens

  // Use the predictions endpoint
  static const String _modelUrl = 'https://api.replicate.com/v1/predictions';
  
  // stability-ai/sdxl version ID
  static const String _versionId = 'da77bc59ee60423279fd632efb4795ab731d9e3ca9705ef3341091fb989b7eaf';

  // Hairstyle to Sample Image Mapping
  static const Map<String, String> _mockHairstyleImages = {
    'Crew Cut': 'https://images.unsplash.com/photo-1590540179852-21102545e23a?q=80&w=800&auto=format&fit=crop',
    'Buzz Cut': 'https://images.unsplash.com/photo-1593351915096-38f0d852abc0?q=80&w=800&auto=format&fit=crop',
    'Sports Buzz': 'https://images.unsplash.com/photo-1563237023-b1e970526dcb?q=80&w=800&auto=format&fit=crop',
    'Clean Short Hair': 'https://images.unsplash.com/photo-1534030347209-467a5b0ad3e6?q=80&w=800&auto=format&fit=crop',
    'Slicked Back': 'https://images.unsplash.com/photo-1548142813-c348350df52b?q=80&w=800&auto=format&fit=crop',
    'Pompadour': 'https://images.unsplash.com/photo-1595152772835-219674b2a8a6?q=80&w=800&auto=format&fit=crop',
    'Comb Over': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=800&auto=format&fit=crop',
    'Side Slick': 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?q=80&w=800&auto=format&fit=crop',
    'Retro Greaser': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=800&auto=format&fit=crop',
    'Undercut': 'https://images.unsplash.com/photo-1531384441138-2736e62e0919?q=80&w=800&auto=format&fit=crop',
    'Textured Hair': 'https://images.unsplash.com/photo-1463453091185-61582044d556?q=80&w=800&auto=format&fit=crop',
    'Messy Hair': 'https://images.unsplash.com/photo-1503443207922-dff7d543fd0e?q=80&w=800&auto=format&fit=crop',
    'Korean Middle Part': 'https://images.unsplash.com/photo-1519345182560-3f2917c472ef?q=80&w=800&auto=format&fit=crop',
    'Mohawk': 'https://images.unsplash.com/photo-1501196351401-f74cf9915d05?q=80&w=800&auto=format&fit=crop',
    'Curly Hair': 'https://images.unsplash.com/photo-1580489944761-15a19d654956?q=80&w=800&auto=format&fit=crop',
    'Stylish Perm': 'https://images.unsplash.com/photo-1513956589380-bad6acb9b9d4?q=80&w=800&auto=format&fit=crop',
    'Tin Foil Perm': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=800&auto=format&fit=crop',
    'Bowl Cut': 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=800&auto=format&fit=crop',
  };

  Future<String> generateHairstyleWithReplicate({
    required String originalImageUrl,
    required String hairstyleName,
  }) async {
    if (_useMock) {
      return await _generateMockHairstyle(hairstyleName);
    }
    
    try {
      debugPrint('🚀 [Replicate] Creating prediction using version endpoint...');
      debugPrint('📡 [Replicate] Endpoint: $_modelUrl');
      debugPrint('🆔 [Replicate] Version: $_versionId');
      debugPrint('🔗 [Replicate] Input Image: $originalImageUrl');
      debugPrint('💇 [Replicate] Hairstyle: $hairstyleName');

      // Prompt template as requested
      final prompt = "Apply hairstyle $hairstyleName. Keep same identity, face, lighting, pose. Only change hair.";
      debugPrint('📝 [Replicate] Prompt: $prompt');

      final response = await http.post(
        Uri.parse(_modelUrl),
        headers: {
          'Authorization': 'Token $_replicateApiToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'version': _versionId,
          'input': {
            'prompt': prompt,
            'image': originalImageUrl, 
            'prompt_strength': 0.75,
            'num_inference_steps': 50,
            'guidance_scale': 7.5,
          }
        }),
      );

      if (response.statusCode == 404) {
        debugPrint('❌ [Replicate] HTTP 404: Resource not found. Check endpoint and version: ${response.body}');
        throw Exception('Replicate resource not found (404). Check API endpoint and version.');
      }

      if (response.statusCode == 422) {
        debugPrint('❌ [Replicate] HTTP 422: Invalid input or model access issue: ${response.body}');
        throw Exception('Replicate model access error (422): ${response.body}');
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        debugPrint('❌ [Replicate] Auth error (${response.statusCode}): ${response.body}');
        throw Exception('Replicate authentication/permission error: ${response.body}');
      }

      if (response.statusCode != 201) {
        debugPrint('❌ [Replicate] Failed to create prediction (${response.statusCode}): ${response.body}');
        throw Exception('Replicate failed to start: ${response.body}');
      }

      final prediction = jsonDecode(response.body);
      final String predictionId = prediction['id'];
      final String getUrl = prediction['urls']['get'];

      debugPrint('📡 [Replicate] Prediction created (ID: $predictionId). Polling for status...');

      // Polling loop
      return await _pollPredictionStatus(getUrl);
    } catch (e) {
      debugPrint('❌ [Replicate] Error: $e');
      rethrow;
    }
  }

  Future<String> _generateMockHairstyle(String hairstyleName) async {
    debugPrint('🛠️ [Mock AI] Starting generation for: $hairstyleName');
    
    // Simulate generation delay
    await Future.delayed(const Duration(seconds: 3));
    
    final mockUrl = _mockHairstyleImages[hairstyleName] ?? 
                    'https://images.unsplash.com/photo-1566492031773-4f4e44671857?q=80&w=800&auto=format&fit=crop';
    
    debugPrint('✅ [Mock AI] Generation complete: $mockUrl');
    return mockUrl;
  }

  Future<String> _pollPredictionStatus(String url) async {
    const int maxAttempts = 30; // ~1 minute max wait
    int attempts = 0;

    while (attempts < maxAttempts) {
      attempts++;
      debugPrint('⏳ [Replicate] Polling... (Attempt $attempts)');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Token $_replicateApiToken',
        },
      );

      if (response.statusCode == 200) {
        final prediction = jsonDecode(response.body);
        final String status = prediction['status'];

        debugPrint('🏷️ [Replicate] Status: $status');

        if (status == 'succeeded') {
          final dynamic output = prediction['output'];
          if (output is List && output.isNotEmpty) {
            return output[0] as String;
          } else if (output is String) {
            return output;
          }
          throw Exception('No output image URL found in Replicate response');
        } else if (status == 'failed' || status == 'canceled') {
          throw Exception('Replicate prediction failed or was canceled');
        }
      } else {
        debugPrint('⚠️ [Replicate] Polling error: ${response.statusCode}');
      }

      await Future.delayed(const Duration(seconds: 2));
    }

    throw Exception('Timed out waiting for Replicate generation');
  }
}
