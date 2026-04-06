import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cloudinaryServiceProvider = Provider<CloudinaryService>(
  (ref) => CloudinaryService(),
);

class CloudinaryService {
  static const String _cloudName = 'di084ig1t';
  static const String _uploadPreset = 'aihairstylist';

  static const String _uploadUrl =
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';

  Future<String> uploadToCloudinary(dynamic imageSource) async {
    try {
      debugPrint('📤 [Cloudinary] Starting upload...');

      final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));
      request.fields['upload_preset'] = _uploadPreset;

      if (imageSource is File) {
        request.files.add(
          await http.MultipartFile.fromPath('file', imageSource.path),
        );
      } else if (imageSource is Uint8List) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            imageSource,
            filename: 'upload.png',
          ),
        );
      } else {
        throw Exception('Invalid image source type');
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(responseData);
        final String url = data['secure_url'];
        debugPrint('✅ [Cloudinary] Upload successful: $url');
        return url;
      } else {
        debugPrint(
          '❌ [Cloudinary] Upload failed (${response.statusCode}): $responseData',
        );
        throw Exception('Cloudinary upload failed: $responseData');
      }
    } catch (e) {
      debugPrint('❌ [Cloudinary] Error: $e');
      throw Exception('Cloudinary upload error: $e');
    }
  }
}
