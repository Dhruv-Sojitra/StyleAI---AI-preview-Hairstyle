import 'package:flutter/material.dart';

class DesignSystem {
  // Colors
  static const Color primaryGradientStart = Color(0xFF6366F1); // Indigo
  static const Color primaryGradientEnd = Color(0xFFA855F7); // Purple
  static const Color secondaryColor = Color(0xFFEC4899); // Pink
  static const Color accentColor = Color(0xFF06B6D4); // Cyan
  
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F172A);
  
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1E293B);

  // Slate colors for UI elements
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGradientStart, primaryGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFD946EF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadows
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 15,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> premiumShadow = [
    BoxShadow(
      color: primaryGradientStart.withValues(alpha: 0.1),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  // Radius
  static const double borderRadius = 20.0;
  static final BorderRadius outerBorderRadius = BorderRadius.circular(borderRadius);
  static final BorderRadius innerBorderRadius = BorderRadius.circular(16.0);

  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // Glassmorphism effect
  static BoxDecoration glassDecoration({required bool isDark}) {
    return BoxDecoration(
      color: isDark 
        ? Colors.white.withValues(alpha: 0.05) 
        : Colors.white.withValues(alpha: 0.7),
      borderRadius: outerBorderRadius,
      border: Border.all(
        color: isDark 
          ? Colors.white.withValues(alpha: 0.1) 
          : Colors.white.withValues(alpha: 0.2),
      ),
    );
  }
}
