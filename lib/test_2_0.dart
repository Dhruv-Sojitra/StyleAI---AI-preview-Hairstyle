import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

void main() async {
  const apiKey = 'AIzaSyAnb0cygheOOQV8g1XjnHDit-h-u7iKe9Q';

  const model = 'gemini-2.0-flash';
  const version = 'v1beta';

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
      debugPrint('Success! Response: ${response.body}');
    } else {
      debugPrint('Failed with status ${response.statusCode}: ${response.body}');
    }
  } catch (e) {
    debugPrint('Error: $e');
  }
}
