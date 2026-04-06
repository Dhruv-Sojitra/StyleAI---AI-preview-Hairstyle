import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';

void main() async {
  const apiKey = 'AIzaSyAnb0cygheOOQV8g1XjnHDit-h-u7iKe9Q';

  final modelsToTest = [
    'gemini-1.5-flash',
    'gemini-1.5-flash-latest',
    'gemini-1.5-pro',
    'gemini-pro-vision',
    'gemini-pro',
  ];

  for (final modelName in modelsToTest) {
    try {
      debugPrint('--- Testing $modelName ---');
      final model = GenerativeModel(model: modelName, apiKey: apiKey);
      final response = await model.generateContent([
        Content.multi([TextPart('hi')]),
      ]);
      debugPrint('Success: ${response.text?.trim()}');
    } catch (e) {
      debugPrint('Failed: $e');
    }
  }
}
