import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
    ),
    scaffoldBackgroundColor: const Color(0xFFF6F8F6),
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF6F8F6),
      foregroundColor: AppColors.onSurface,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE7ECE8)),
      ),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, height: 1.2),
      titleLarge: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
      titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, height: 1.45),
      bodySmall: TextStyle(fontSize: 12, height: 1.4),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: AppColors.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: AppColors.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.7),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.outlineVariant,
      thickness: 1,
      space: 1,
    ),
    visualDensity: VisualDensity.standard,
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryDark,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.outlineDark),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.onSurfaceDark,
      elevation: 0,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      ),
    ),
    visualDensity: VisualDensity.standard,
  );
}
