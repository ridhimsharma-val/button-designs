import 'package:flutter/material.dart';

/// Centralized color system and visual styling for ButtonLab.
/// Strictly implements the warm Terracotta + Cream palette.
class AppTheme {
  AppTheme._();

  // --- Terracotta + Cream Color Palette ---
  static const Color primaryTerracotta = Color(0xFFC45A36);
  static const Color darkTerracotta = Color(0xFF9D4127);
  static const Color lightTerracotta = Color(0xFFF7E3D8);
  static const Color mainBackground = Color(0xFFFFF8F0);
  static const Color warmNeutral = Color(0xFFE9D5C5);
  static const Color primaryText = Color(0xFF35251F);
  static const Color secondaryText = Color(0xFF8C766B);
  static const Color whiteSurface = Color(0xFFFFFFFF);

  // Selector specific tokens (matching the reference)
  static const Color selectorBackground = Color(0xFFEFE8E2);
  static const Color selectorBorder = Color(0xFFE3D9D0);
  static const Color selectorPillActive = Color(0xFFFFFFFF);
  static const Color selectorTextInactive = Color(0xFF8C766B);
  static const Color selectorTextActive = Color(0xFFC45A36);

  // Desktop backdrop
  static const Color desktopBackdrop = Color(0xFFF5EFE9);

  // --- Gradients ---
  static const LinearGradient terracottaGradient = LinearGradient(
    colors: [darkTerracotta, primaryTerracotta],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient softWarmGradient = LinearGradient(
    colors: [primaryTerracotta, Color(0xFFDE7955)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- ThemeData ---
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: mainBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryTerracotta,
        primary: primaryTerracotta,
        surface: whiteSurface,
        onPrimary: whiteSurface,
        onSurface: primaryText,
      ),
      fontFamily: null,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        titleMedium: TextStyle(
          color: primaryText,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(color: secondaryText, fontSize: 13, height: 1.4),
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}
