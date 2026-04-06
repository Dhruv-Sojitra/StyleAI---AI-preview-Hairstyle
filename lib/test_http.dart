import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

void main() async {
  const apiKey = 'AIzaSyAnb0cygheOOQV8g1XjnHDit-h-u7iKe9Q';

  final versions = ['v1', 'v1beta'];
  final models = ['gemini-1.5-flash', 'gemini-1.5-pro', 'gemini-pro'];

  for (final version in versions) {
    for (final model in models) {
      debugPrint('--- Testing $model ($version) ---');
      try {
        final url =
            'https://generativelanguage.googleapis.com/$version/models/$model:generateContent?key=$apiKey';
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': 'hi'},
                ],
              },
            ],
          }),
        );

        if (response.statusCode == 200) {
          debugPrint('Success! Response: ${response.body.substring(0, 50)}...');
        } else {
          debugPrint(
            'Failed with status ${response.statusCode}: ${response.body}',
          );
        }
      } catch (e) {
        debugPrint('Error: $e');
      }
    }
  }
}
