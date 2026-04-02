import 'package:cloud_firestore/cloud_firestore.dart';

class GenerationResult {
  final String id;
  final String userId;
  final String originalImageUrl;
  final String generatedImageUrl;
  final String hairstyleName;
  final DateTime timestamp;

  final bool isFavorite;

  GenerationResult({
    required this.id,
    required this.userId,
    required this.originalImageUrl,
    required this.generatedImageUrl,
    required this.hairstyleName,
    required this.timestamp,
    this.isFavorite = false,
  });

  factory GenerationResult.fromMap(Map<String, dynamic> data, String id) {
    return GenerationResult(
      id: id,
      userId: data['userId'] ?? '',
      originalImageUrl: data['originalImageUrl'] ?? '',
      generatedImageUrl: data['generatedImageUrl'] ?? '',
      hairstyleName: data['hairstyleName'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isFavorite: data['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'originalImageUrl': originalImageUrl,
      'generatedImageUrl': generatedImageUrl,
      'hairstyleName': hairstyleName,
      'timestamp': Timestamp.fromDate(timestamp),
      'isFavorite': isFavorite,
    };
  }
}
