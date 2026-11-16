import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static final ThemeData light = ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, primary: AppColors.primary, secondary: AppColors.secondary, surface: AppColors.surface), scaffoldBackgroundColor: AppColors.background, appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: AppColors.onSurface, elevation: 0), cardTheme: CardThemeData(color: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))), fontFamily: 'Roboto');
  static final ThemeData dark = ThemeData(useMaterial3: true, brightness: Brightness.dark, colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryDark, brightness: Brightness.dark), scaffoldBackgroundColor: AppColors.backgroundDark, cardTheme: CardThemeData(color: AppColors.surfaceDark, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))));
}
