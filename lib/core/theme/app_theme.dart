import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      surface: const Color(0xFFFFFEFA),
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: const Color(0xFFF4F7F5),
    fontFamily: 'Roboto',
    splashFactory: InkSparkle.splashFactory,
    iconTheme: const IconThemeData(color: Color(0xFF245A45)),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF4F7F5),
      foregroundColor: Color(0xFF18352B),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(color: Color(0xFF18352B), fontSize: 19, fontWeight: FontWeight.w900, letterSpacing: .35),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFFFFFEFA),
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE4ECE7)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: const Color(0xFFFFFEFA),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: const TextStyle(
        color: Color(0xFF18352B),
        fontSize: 20,
        fontWeight: FontWeight.w900,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xFF18352B),
      contentTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: Color(0xFFDCEBE2),
      circularTrackColor: Color(0xFFDCEBE2),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, height: 1.12),
      headlineSmall: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, height: 1.18),
      titleLarge: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
      titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, height: 1.45),
      bodySmall: TextStyle(fontSize: 12, height: 1.4),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 50),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFFB8CFC3),
        disabledForegroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48), padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12), foregroundColor: AppColors.primary, side: const BorderSide(color: Color(0xFFB8D5C6)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800))),
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: AppColors.primary, textStyle: const TextStyle(fontWeight: FontWeight.w800), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      hintStyle: const TextStyle(color: Color(0xFF87958D), fontSize: 14),
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFE0E9E3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFE0E9E3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.error, width: 1.8),
      ),
    ),
    chipTheme: ChipThemeData(backgroundColor: const Color(0xFFEAF4EE), selectedColor: const Color(0xFFD5EBDD), side: BorderSide.none, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
    dividerTheme: const DividerThemeData(color: Color(0xFFE5ECE7), thickness: 1, space: 1),
    navigationBarTheme: NavigationBarThemeData(height: 68, backgroundColor: Colors.white, indicatorColor: const Color(0xFFE4F2E9), labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(fontSize: 11, fontWeight: states.contains(WidgetState.selected) ? FontWeight.w900 : FontWeight.w600))),
    visualDensity: VisualDensity.standard,
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryDark, brightness: Brightness.dark, primary: AppColors.primaryDark, secondary: AppColors.secondaryDark),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    iconTheme: const IconThemeData(color: AppColors.onSurfaceDark),
    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.outlineDark),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: const TextStyle(
        color: AppColors.onSurfaceDark,
        fontSize: 20,
        fontWeight: FontWeight.w900,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xFF303A42),
      contentTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primaryDark,
      linearTrackColor: Color(0xFF34443C),
      circularTrackColor: Color(0xFF34443C),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceVariantDark,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      hintStyle: const TextStyle(color: AppColors.onSurfaceVariantDark),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.outlineDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.outlineDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.8),
      ),
    ),
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.backgroundDark, foregroundColor: AppColors.onSurfaceDark, elevation: 0, scrolledUnderElevation: 0, titleTextStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 50),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.onPrimaryDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        foregroundColor: AppColors.primaryDark,
        side: const BorderSide(color: AppColors.outlineDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
      ),
    ),
    visualDensity: VisualDensity.standard,
  );
}