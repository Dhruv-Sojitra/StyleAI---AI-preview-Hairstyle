import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design_system.dart';

class AppTheme {
  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 32),
      displayMedium: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 28),
      displaySmall: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 24),
      headlineLarge: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22),
      headlineMedium: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20),
      headlineSmall: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 18),
      titleLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
      titleMedium: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 16),
      titleSmall: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14),
      bodyLarge: GoogleFonts.inter(fontSize: 16),
      bodyMedium: GoogleFonts.inter(fontSize: 14),
      bodySmall: GoogleFonts.inter(fontSize: 12),
      labelLarge: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
    );
  }

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: DesignSystem.primaryGradientStart,
      primary: DesignSystem.primaryGradientStart,
      secondary: DesignSystem.secondaryColor,
      surface: DesignSystem.backgroundLight,
      brightness: Brightness.light,
    ),
    textTheme: _buildTextTheme(ThemeData.light().textTheme),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: DesignSystem.slate900,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: DesignSystem.slate900,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: DesignSystem.outerBorderRadius),
        elevation: 0,
        backgroundColor: DesignSystem.primaryGradientStart,
        foregroundColor: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: DesignSystem.outerBorderRadius),
      elevation: 0,
      color: DesignSystem.cardLight,
      clipBehavior: Clip.antiAlias,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: DesignSystem.outerBorderRadius,
        borderSide: const BorderSide(color: DesignSystem.slate100, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: DesignSystem.outerBorderRadius,
        borderSide: const BorderSide(color: DesignSystem.slate100, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: DesignSystem.outerBorderRadius,
        borderSide: const BorderSide(color: DesignSystem.primaryGradientStart, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: DesignSystem.outerBorderRadius,
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      hintStyle: GoogleFonts.inter(color: DesignSystem.slate400, fontSize: 14),
    ),
    dividerTheme: const DividerThemeData(
      color: DesignSystem.slate100,
      thickness: 1,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: DesignSystem.primaryGradientStart,
      primary: DesignSystem.primaryGradientStart,
      secondary: DesignSystem.secondaryColor,
      surface: DesignSystem.backgroundDark,
      brightness: Brightness.dark,
    ),
    textTheme: _buildTextTheme(ThemeData.dark().textTheme),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: DesignSystem.outerBorderRadius),
        elevation: 0,
        backgroundColor: DesignSystem.primaryGradientStart,
        foregroundColor: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: DesignSystem.outerBorderRadius),
      elevation: 0,
      color: DesignSystem.cardDark,
      clipBehavior: Clip.antiAlias,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E293B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: DesignSystem.outerBorderRadius,
        borderSide: const BorderSide(color: DesignSystem.slate800, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: DesignSystem.outerBorderRadius,
        borderSide: const BorderSide(color: DesignSystem.slate800, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: DesignSystem.outerBorderRadius,
        borderSide: const BorderSide(color: DesignSystem.primaryGradientStart, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: DesignSystem.outerBorderRadius,
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      hintStyle: GoogleFonts.inter(color: DesignSystem.slate500, fontSize: 14),
    ),
    dividerTheme: const DividerThemeData(
      color: DesignSystem.slate800,
      thickness: 1,
    ),
  );
}
