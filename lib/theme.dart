import 'package:flutter/material.dart';

/// Learnify App Theme
/// Colors extracted from the Stitch-generated design (violet/indigo palette)

class AppColors {
  // Dark theme colors (from Stitch design)
  static const darkBackground = Color(0xFF15121B);
  static const darkSurface = Color(0xFF15121B);
  static const darkSurfaceContainer = Color(0xFF211E27);
  static const darkSurfaceContainerLow = Color(0xFF1D1A23);
  static const darkSurfaceContainerLowest = Color(0xFF0F0D15);
  static const darkSurfaceContainerHigh = Color(0xFF2C2832);
  static const darkSurfaceContainerHighest = Color(0xFF37333D);
  static const darkOnBackground = Color(0xFFE7E0ED);
  static const darkOnSurface = Color(0xFFE7E0ED);
  static const darkOnSurfaceVariant = Color(0xFFCBC3D7);
  static const darkOutline = Color(0xFF958EA0);
  static const darkOutlineVariant = Color(0xFF494454);

  static const primary = Color(0xFFD0BCFF);
  static const primaryContainer = Color(0xFFA078FF);
  static const onPrimary = Color(0xFF3C0091);
  static const onPrimaryContainer = Color(0xFF340080);
  static const inversePrimary = Color(0xFF6D3BD7);

  static const secondary = Color(0xFF5DE6FF);
  static const secondaryContainer = Color(0xFF00CBE6);
  static const onSecondary = Color(0xFF00363E);

  static const tertiary = Color(0xFFFFB95F);
  static const tertiaryContainer = Color(0xFFCA8100);
  static const onTertiary = Color(0xFF472A00);

  static const error = Color(0xFFFFB4AB);
  static const errorContainer = Color(0xFF93000A);
  static const onError = Color(0xFF690005);

  // Light theme colors (inverted, same hue family)
  static const lightBackground = Color(0xFFFBF8FF);
  static const lightSurface = Color(0xFFFBF8FF);
  static const lightSurfaceContainer = Color(0xFFF1ECF7);
  static const lightSurfaceContainerLow = Color(0xFFF5F0FA);
  static const lightSurfaceContainerLowest = Color(0xFFFFFFFF);
  static const lightSurfaceContainerHigh = Color(0xFFEBE6F1);
  static const lightSurfaceContainerHighest = Color(0xFFE5E0EB);
  static const lightOnBackground = Color(0xFF1D1A23);
  static const lightOnSurface = Color(0xFF1D1A23);
  static const lightOnSurfaceVariant = Color(0xFF48454E);
  static const lightOutline = Color(0xFF79747E);
  static const lightOutlineVariant = Color(0xFFCAC4CF);

  static const lightPrimary = Color(0xFF6D3BD7);
  static const lightPrimaryContainer = Color(0xFFE9DDFF);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightOnPrimaryContainer = Color(0xFF23005C);

  static const lightSecondary = Color(0xFF00838F);
  static const lightSecondaryContainer = Color(0xFFA2EEFF);
  static const lightOnSecondary = Color(0xFFFFFFFF);

  static const lightTertiary = Color(0xFF8B5A00);
  static const lightTertiaryContainer = Color(0xFFFFDDB8);
  static const lightOnTertiary = Color(0xFFFFFFFF);

  static const lightError = Color(0xFFBA1A1A);
  static const lightErrorContainer = Color(0xFFFFDAD6);
  static const lightOnError = Color(0xFFFFFFFF);

  // Gradients (used across both themes on buttons/progress)
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFD946EF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

class AppTextStyles {
  static const displayLg = TextStyle(
    fontFamily: 'Geist',
    fontSize: 48,
    height: 52 / 48,
    letterSpacing: -0.04 * 48,
    fontWeight: FontWeight.w800,
  );

  static const headlineLg = TextStyle(
    fontFamily: 'Geist',
    fontSize: 32,
    height: 40 / 32,
    letterSpacing: -0.03 * 32,
    fontWeight: FontWeight.w700,
  );

  static const headlineLgMobile = TextStyle(
    fontFamily: 'Geist',
    fontSize: 28,
    height: 34 / 28,
    letterSpacing: -0.02 * 28,
    fontWeight: FontWeight.w700,
  );

  static const headlineMd = TextStyle(
    fontFamily: 'Geist',
    fontSize: 24,
    height: 32 / 24,
    letterSpacing: -0.02 * 24,
    fontWeight: FontWeight.w600,
  );

  static const labelMd = TextStyle(
    fontFamily: 'Geist',
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0.02 * 14,
    fontWeight: FontWeight.w600,
  );

  static const bodyLg = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    height: 28 / 18,
    fontWeight: FontWeight.w400,
  );

  static const bodyMd = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
  );

  static const caption = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    height: 16 / 12,
    letterSpacing: 0.01 * 12,
    fontWeight: FontWeight.w500,
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        onSurfaceVariant: AppColors.darkOnSurfaceVariant,
        outline: AppColors.darkOutline,
        outlineVariant: AppColors.darkOutlineVariant,
        inversePrimary: AppColors.inversePrimary,
      ),
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLg,
        headlineLarge: AppTextStyles.headlineLg,
        headlineMedium: AppTextStyles.headlineMd,
        labelMedium: AppTextStyles.labelMd,
        bodyLarge: AppTextStyles.bodyLg,
        bodyMedium: AppTextStyles.bodyMd,
        bodySmall: AppTextStyles.caption,
      ).apply(
        bodyColor: AppColors.darkOnBackground,
        displayColor: AppColors.darkOnBackground,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        onPrimary: AppColors.lightOnPrimary,
        primaryContainer: AppColors.lightPrimaryContainer,
        onPrimaryContainer: AppColors.lightOnPrimaryContainer,
        secondary: AppColors.lightSecondary,
        onSecondary: AppColors.lightOnSecondary,
        secondaryContainer: AppColors.lightSecondaryContainer,
        tertiary: AppColors.lightTertiary,
        onTertiary: AppColors.lightOnTertiary,
        tertiaryContainer: AppColors.lightTertiaryContainer,
        error: AppColors.lightError,
        onError: AppColors.lightOnError,
        errorContainer: AppColors.lightErrorContainer,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightOnSurface,
        onSurfaceVariant: AppColors.lightOnSurfaceVariant,
        outline: AppColors.lightOutline,
        outlineVariant: AppColors.lightOutlineVariant,
      ),
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLg,
        headlineLarge: AppTextStyles.headlineLg,
        headlineMedium: AppTextStyles.headlineMd,
        labelMedium: AppTextStyles.labelMd,
        bodyLarge: AppTextStyles.bodyLg,
        bodyMedium: AppTextStyles.bodyMd,
        bodySmall: AppTextStyles.caption,
      ).apply(
        bodyColor: AppColors.lightOnBackground,
        displayColor: AppColors.lightOnBackground,
      ),
    );
  }
}

/// Global notifier to toggle theme mode from anywhere in the app
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.dark);