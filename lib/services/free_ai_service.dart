import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final freeAiServiceProvider = Provider<FreeAIService>((ref) => FreeAIService());

class FreeAIService {
  static const String _hfToken = 'YOUR_HUGGING_FACE_API_TOKEN';

  static const String _modelUrl =
      'https://router.huggingface.co/hf-inference/models/runwayml/stable-diffusion-v1-5';

  Future<Uint8List> generateHairstyleImage({
    required Uint8List imageBytes,
    required String hairstyle,
  }) async {
    try {
      debugPrint(
        '🚀 [FreeAI] Starting Image-to-Image generation for: $hairstyle',
      );

      final String base64Image = base64Encode(imageBytes);
      final String inputPrompt =
          "A high-quality portrait of a person with a $hairstyle hairstyle, matching the lighting and face of the original image, professional photography, highly detailed";

      debugPrint('📝 [FreeAI] Prompt: $inputPrompt');

      final response = await http.post(
        Uri.parse(_modelUrl),
        headers: {
          'Authorization': 'Bearer $_hfToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'inputs': inputPrompt,
          'parameters': {'init_image': base64Image, 'strength': 0.6},
        }),
      );

      debugPrint('📡 [FreeAI] Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint(
          '✅ [FreeAI] Generation Success! Size: ${response.bodyBytes.length} bytes',
        );
        return response.bodyBytes;
      } else {
        final String errorBody = response.body;
        debugPrint('❌ [FreeAI] API Error (${response.statusCode}): $errorBody');

        if (errorBody.contains('currently loading')) {
          throw Exception(
            'AI Model is currently loading. Please wait 1-2 minutes and try again.',
          );
        }

        throw Exception('AI Generation failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ [FreeAI] Exception: $e');
      rethrow;
    }
  }
}
