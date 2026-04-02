import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

void main() async {
  const apiKey = 'AIzaSyAnb0cygheOOQV8g1XjnHDit-h-u7iKe9Q';
  
  try {
    debugPrint('Listing models for v1beta...');
    final url = 'https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      debugPrint('Success! Available models:');
      final data = jsonDecode(response.body);
      final models = data['models'] as List;
      for (var m in models) {
        debugPrint('- ${m['name']} (${m['displayName']})');
      }
    } else {
      debugPrint('Failed listing v1beta: ${response.statusCode} - ${response.body}');
    }

    debugPrint('\nListing models for v1...');
    final urlV1 = 'https://generativelanguage.googleapis.com/v1/models?key=$apiKey';
    final responseV1 = await http.get(Uri.parse(urlV1));

    if (responseV1.statusCode == 200) {
      debugPrint('Success! Available models (v1):');
      final dataV1 = jsonDecode(responseV1.body);
      final modelsV1 = dataV1['models'] as List;
      for (var m in modelsV1) {
        debugPrint('- ${m['name']} (${m['displayName']})');
      }
    } else {
      debugPrint('Failed listing v1: ${responseV1.statusCode} - ${responseV1.body}');
    }

  } catch (e) {
    debugPrint('Error: $e');
  }
}
