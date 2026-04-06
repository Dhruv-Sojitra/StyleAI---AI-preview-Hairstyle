import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final falServiceProvider = Provider<FalService>((ref) => FalService());

class FalService {
  static const String _falApiKey =
      '7499fcd8-3614-4f76-8380-6ddcf81a852e:54fd3d36dac486228c2266d5376559ea';

  static const String _apiUrl =
      'https://fal.run/fal-ai/fast-sdxl/image-to-image';

  Future<String> generateHairstyleWithFal({
    required String originalImageUrl,
    required String hairstyleName,
  }) async {
    if (originalImageUrl.isEmpty || !Uri.parse(originalImageUrl).isAbsolute) {
      debugPrint('❌ [FAL.ai] Invalid image URL: $originalImageUrl');
      throw Exception('Invalid image URL provided for generation.');
    }

    int attempts = 0;
    const int maxAttempts = 2;

    while (attempts < maxAttempts) {
      attempts++;
      try {
        debugPrint(
          '🚀 [FAL.ai] Starting hairstyle generation (Attempt $attempts)...',
        );
        debugPrint('🔗 [FAL.ai] Input Image: $originalImageUrl');
        debugPrint('💇 [FAL.ai] Hairstyle: $hairstyleName');

        final String prompt = attempts == 1
            ? "Edit the hairstyle of this person to $hairstyleName. Preserve exact face identity, facial features, skin texture, expression, pose, lighting, and background. Do NOT modify face shape or identity. Only change hair realistically with natural blending. Photorealistic."
            : "Photo of a person with $hairstyleName hairstyle, high quality, natural hair blending, maintaining face identity.";

        const String negativePrompt =
            "cartoon, anime, painting, illustration, distorted face, different person, low quality";

        debugPrint('📝 [FAL.ai] Prompt: $prompt');

        final response = await http.post(
          Uri.parse(_apiUrl),
          headers: {
            'Authorization': 'Key $_falApiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'image_url': originalImageUrl,
            'prompt': prompt,
            'negative_prompt': negativePrompt,
            'strength': 0.45,
            'guidance_scale': 4.0,
            'image_size': 'square_hd',
            'num_inference_steps': 40,
            'enable_safety_checker': true,
          }),
        );

        debugPrint('📡 [FAL.ai] Status Code: ${response.statusCode}');

        if (response.statusCode != 200) {
          debugPrint('❌ [FAL.ai] Error Response: ${response.body}');
          if (attempts < maxAttempts) continue;
          throw Exception('FAL.ai failed: ${response.body}');
        }

        final data = jsonDecode(response.body);
        String? generatedUrl;

        if (data['images'] != null && data['images'].isNotEmpty) {
          generatedUrl = data['images'][0]['url'];
        } else if (data['image'] != null) {
          generatedUrl = data['image']['url'];
        }

        if (generatedUrl != null && generatedUrl.isNotEmpty) {
          debugPrint('✅ [FAL.ai] Generation Success: $generatedUrl');
          return generatedUrl;
        }

        if (attempts < maxAttempts) {
          debugPrint('⚠️ [FAL.ai] Empty result, retrying...');
          continue;
        }
        throw Exception('No output image URL found in FAL.ai response');
      } catch (e) {
        debugPrint('❌ [FAL.ai] Exception (Attempt $attempts): $e');
        if (attempts >= maxAttempts) rethrow;
      }
    }
    throw Exception('FAL.ai generation failed after $maxAttempts attempts');
  }
}
