import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF0F0F1A);
  static const surface = Color(0xFF1A1A2E);
  static const surfaceLight = Color(0xFF252540);
  static const primary = Color(0xFF7C5CFC);
  static const primaryLight = Color(0xFF9B7FFF);
  static const danger = Color(0xFFFF6B6B);
  static const dangerBg = Color(0x1AFF4444);
  static const warning = Color(0xFFFFCC44);
  static const warningBg = Color(0x1AFFAA00);
  static const success = Color(0xFF44DD88);
  static const successBg = Color(0x1A00CC66);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFAAAAAA);
  static const textMuted = Color(0xFF555566);
  static const border = Color(0xFF2D2D44);
  static const codeBg = Color(0xFF0A0A14);
}

class AppTheme {
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.surface,
          background: AppColors.background,
        ),
        fontFamily: 'SF Pro Display',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMuted,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
      );
}
