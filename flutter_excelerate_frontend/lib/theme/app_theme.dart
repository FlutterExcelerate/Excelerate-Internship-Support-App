import 'package:flutter/material.dart';

class LearnifyColors {
  const LearnifyColors._();

  static const ink = Color(0xFF172126);
  static const muted = Color(0xFF667085);
  static const canvas = Color(0xFFF7FAF9);
  static const surface = Color(0xFFFFFFFF);
  static const primary = Color(0xFF116A72);
  static const primaryDark = Color(0xFF0B4A52);
  static const secondary = Color(0xFF5A67D8);
  static const wellness = Color(0xFFF4A340);
  static const success = Color(0xFF24A36B);
  static const warning = Color(0xFFE68A00);
  static const info = Color(0xFF2F80ED);
}

class LearnifyTheme {
  const LearnifyTheme._();

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: LearnifyColors.primary,
      brightness: Brightness.light,
      primary: LearnifyColors.primary,
      secondary: LearnifyColors.secondary,
      surface: LearnifyColors.surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: LearnifyColors.canvas,
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          color: LearnifyColors.ink,
        ),
        headlineMedium: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: LearnifyColors.ink,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: LearnifyColors.ink,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: LearnifyColors.ink,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.45,
          color: LearnifyColors.ink,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.45,
          color: LearnifyColors.muted,
        ),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: LearnifyColors.canvas,
        foregroundColor: LearnifyColors.ink,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: LearnifyColors.ink,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: LearnifyColors.surface,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: LearnifyColors.ink.withValues(alpha: 0.07)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: LearnifyColors.surface,
        hintStyle: const TextStyle(color: LearnifyColors.muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: LearnifyColors.ink.withValues(alpha: 0.07),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: LearnifyColors.primary,
            width: 1.4,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: LearnifyColors.ink,
          minimumSize: const Size(0, 52),
          side: BorderSide(color: LearnifyColors.ink.withValues(alpha: 0.12)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 72,
        backgroundColor: LearnifyColors.surface,
        indicatorColor: LearnifyColors.primary.withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
            color: states.contains(WidgetState.selected)
                ? LearnifyColors.primary
                : LearnifyColors.muted,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: LearnifyColors.primary.withValues(alpha: 0.08),
        selectedColor: LearnifyColors.primary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
    );
  }
}
