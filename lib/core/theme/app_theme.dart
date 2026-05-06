// ============================================================
// StockSmart – Premium App Theme Configuration
// Sophisticated Material 3 Design System
// ============================================================

import 'package:flutter/material.dart';

/// Premium application color system
/// Deep Indigo primary with warm Coral accents — enterprise-grade palette
class AppColors {
  // ── Primary Palette (Deep Indigo System) ──
  static const Color primary = Color(0xFF4F46E5);       // Indigo 600
  static const Color primaryLight = Color(0xFF818CF8);   // Indigo 400
  static const Color primaryDark = Color(0xFF3730A3);    // Indigo 800
  static const Color secondary = Color(0xFF7C3AED);      // Violet 600
  static const Color accent = Color(0xFFF97316);          // Warm Orange accent

  // ── Background & Surface ──
  static const Color background = Color(0xFFF1F5F9);     // Slate 100
  static const Color cardColor = Colors.white;
  static const Color surfaceElevated = Color(0xFFFAFAFF); // Slight blue-white tint
  static const Color borderColor = Color(0xFFE2E8F0);    // Slate 200

  // ── Text Hierarchy ──
  static const Color darkText = Color(0xFF1E293B);       // Slate 800
  static const Color mediumText = Color(0xFF475569);      // Slate 600
  static const Color lightText = Color(0xFF94A3B8);       // Slate 400
  static const Color inverseText = Colors.white;

  // ── Semantic Status Colors ──
  static const Color success = Color(0xFF059669);         // Emerald 600
  static const Color successLight = Color(0xFFD1FAE5);    // Emerald 100
  static const Color warning = Color(0xFFD97706);         // Amber 600
  static const Color warningLight = Color(0xFFFEF3C7);    // Amber 100
  static const Color danger = Color(0xFFDC2626);          // Red 600
  static const Color dangerLight = Color(0xFFFEE2E2);     // Red 100
  static const Color info = Color(0xFF0284C7);            // Sky 600
  static const Color infoLight = Color(0xFFE0F2FE);       // Sky 100

  // ── Chart & Visualization Palette ──
  static const Color chartIndigo = Color(0xFF6366F1);
  static const Color chartViolet = Color(0xFF8B5CF6);
  static const Color chartSky = Color(0xFF0EA5E9);
  static const Color chartTeal = Color(0xFF14B8A6);
  static const Color chartAmber = Color(0xFFF59E0B);
  static const Color chartRose = Color(0xFFF43F5E);
  static const Color chartEmerald = Color(0xFF10B981);
  static const Color chartOrange = Color(0xFFF97316);

  // ── Gradient Presets ──
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFFC026D3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFFB923C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF059669), Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF312E81), Color(0xFF4F46E5), Color(0xFF7C3AED)],
    stops: [0.0, 0.5, 1.0],
  );
}

/// Application theme data configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.cardColor,
        error: AppColors.danger,
        brightness: Brightness.light,
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.darkText,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: AppColors.darkText),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.zero,
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        hintStyle: const TextStyle(color: AppColors.lightText, fontSize: 14, fontWeight: FontWeight.w400),
        labelStyle: const TextStyle(color: AppColors.mediumText, fontSize: 14),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.3),
        ),
      ),

      // FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      // Bottom Nav
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.cardColor,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.lightText,
        type: BottomNavigationBarType.fixed,
        elevation: 20,
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceElevated,
        selectedColor: AppColors.primary.withValues(alpha: 0.12),
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: const BorderSide(color: AppColors.borderColor),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.darkText,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColors.cardColor,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.borderColor,
        thickness: 1,
        space: 1,
      ),

      // Text theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.darkText, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -1),
        displayMedium: TextStyle(color: AppColors.darkText, fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.5),
        headlineLarge: TextStyle(color: AppColors.darkText, fontSize: 24, fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(color: AppColors.darkText, fontSize: 20, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: AppColors.darkText, fontSize: 18, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: AppColors.darkText, fontSize: 16, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: AppColors.darkText, fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(color: AppColors.mediumText, fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(color: AppColors.lightText, fontSize: 12, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
