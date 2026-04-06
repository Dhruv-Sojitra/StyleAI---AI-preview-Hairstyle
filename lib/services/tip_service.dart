import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TipModel {
  final String title;
  final String description;
  final String imageUrl;

  const TipModel({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}

class TipService {
  final List<TipModel> _tips = [
    const TipModel(
      title: 'The Modern Quiff',
      description:
          'Volume at the top, short sides. Perfect for oval and square faces.',
      imageUrl:
          'https://images.unsplash.com/photo-1605497788044-5a32c7078486?q=80&w=800',
    ),
    const TipModel(
      title: 'Textured Crop',
      description:
          'Low maintenance and stylish. Great for adding texture to straight hair.',
      imageUrl:
          'https://images.unsplash.com/photo-1621605815971-fbc98d665033?q=80&w=800',
    ),
    const TipModel(
      title: 'Long & Layered',
      description: 'Soft layers add movement and dimension to long hair.',
      imageUrl:
          'https://images.unsplash.com/photo-1519699047748-de8e457a634e?q=80&w=800',
    ),
    const TipModel(
      title: 'Classic Pompadour',
      description: 'A timeless look that screams confidence and style.',
      imageUrl:
          'https://images.unsplash.com/photo-1549473448-5d718f75fac4?q=80&w=800',
    ),
    const TipModel(
      title: 'Wavy Bob',
      description: 'Chic and effortless. A versatile cut for any occasion.',
      imageUrl:
          'https://images.unsplash.com/photo-1560869713-7d0a29430863?q=80&w=800',
    ),
  ];

  TipModel getDailyTip() {
    final random = Random();
    return _tips[random.nextInt(_tips.length)];
  }

  List<TipModel> getAllTips() => _tips;
}

final tipServiceProvider = Provider<TipService>((ref) => TipService());
