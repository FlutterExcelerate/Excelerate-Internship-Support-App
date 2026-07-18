import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class 
LearnifyColors {
  const LearnifyColors._();
  static const primary = Color(0xFF0F766E); 
  static const primaryDark = Color(0xFF14B8A6);
  static const secondary = Color(0xFF4F46E5);
  static const secondaryLight = Color(0xFF818CF8);
  
  static const wellness = Color(0xFFF59E0B); 
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);

  static const inkLight = Color(0xFF0F172A);
  static const mutedLight = Color(0xFF64748B);
  static const canvasLight = Color(0xFFF8FAFC);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const borderLight = Color(0xFFE2E8F0);

  static const inkDark = Color(0xFFF8FAFC);
  static const mutedDark = Color(0xFF94A3B8);
  static const canvasDark = Color(0xFF0B0F19);
  static const surfaceDark = Color(0xFF151D30);
  static const borderDark = Color(0xFF1E293B);

  static const ink = inkLight;
  static const muted = mutedLight;
  static const canvas = canvasLight;
  static const surface = surfaceLight;
}

class LearnifyTheme {
  const LearnifyTheme._();

  static TextTheme _buildTextTheme(Color inkColor, Color mutedColor) {
    return TextTheme(
      displaySmall: GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: inkColor,
        letterSpacing: -1.0,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: inkColor,
        letterSpacing: -0.5,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: inkColor,
        letterSpacing: -0.3,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: inkColor,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 15,
        height: 1.5,
        fontWeight: FontWeight.w500,
        color: inkColor,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 13,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: mutedColor,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: inkColor,
      ),
    );
  }

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: LearnifyColors.primary,
      brightness: Brightness.light,
      primary: LearnifyColors.primary,
      secondary: LearnifyColors.secondary,
      surface: LearnifyColors.surfaceLight,
      error: LearnifyColors.warning,
      outlineVariant: LearnifyColors.borderLight,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: LearnifyColors.canvasLight,
      brightness: Brightness.light,
      textTheme: _buildTextTheme(LearnifyColors.inkLight, LearnifyColors.mutedLight),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: LearnifyColors.canvasLight,
        foregroundColor: LearnifyColors.inkLight,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: LearnifyColors.inkLight,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: LearnifyColors.surfaceLight,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: LearnifyColors.borderLight),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: LearnifyColors.surfaceLight,
        hintStyle: const TextStyle(color: LearnifyColors.mutedLight),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: LearnifyColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: LearnifyColors.primary,
            width: 1.6,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: LearnifyColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 52),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: LearnifyColors.inkLight,
          minimumSize: const Size(0, 52),
          side: const BorderSide(color: LearnifyColors.borderLight, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 72,
        backgroundColor: LearnifyColors.surfaceLight,
        indicatorColor: LearnifyColors.primary.withValues(alpha: 0.08),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? LearnifyColors.primary
                : LearnifyColors.mutedLight,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: LearnifyColors.primary.withValues(alpha: 0.06),
        selectedColor: LearnifyColors.primary,
        labelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: LearnifyColors.primaryDark,
      brightness: Brightness.dark,
      primary: LearnifyColors.primaryDark,
      secondary: LearnifyColors.secondaryLight,
      surface: LearnifyColors.surfaceDark,
      error: LearnifyColors.warning,
      outlineVariant: LearnifyColors.borderDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: LearnifyColors.canvasDark,
      brightness: Brightness.dark,
      textTheme: _buildTextTheme(LearnifyColors.inkDark, LearnifyColors.mutedDark),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: LearnifyColors.canvasDark,
        foregroundColor: LearnifyColors.inkDark,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: LearnifyColors.inkDark,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: LearnifyColors.surfaceDark,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: LearnifyColors.borderDark),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: LearnifyColors.surfaceDark,
        hintStyle: const TextStyle(color: LearnifyColors.mutedDark),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: LearnifyColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: LearnifyColors.primaryDark,
            width: 1.6,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: LearnifyColors.primaryDark,
          foregroundColor: LearnifyColors.canvasDark,
          minimumSize: const Size(0, 52),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: LearnifyColors.inkDark,
          minimumSize: const Size(0, 52),
          side: const BorderSide(color: LearnifyColors.borderDark, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 72,
        backgroundColor: LearnifyColors.surfaceDark,
        indicatorColor: LearnifyColors.primaryDark.withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? LearnifyColors.primaryDark
                : LearnifyColors.mutedDark,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: LearnifyColors.primaryDark.withValues(alpha: 0.1),
        selectedColor: LearnifyColors.primaryDark,
        labelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
    );
  }
}
