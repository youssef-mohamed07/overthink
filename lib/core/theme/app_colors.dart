import 'package:flutter/material.dart';

class AppColors {
  // New Palette based on provided design
  static const Color primary = Color(0xFFBB86FC);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color tertiary = Color(0xFFCF6679); // Often used for errors/destructive

  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  
  static const Color textDark = Color(0xFFFFFFFF);
  static const Color textDarkSecondary = Color(0xB3FFFFFF); // 70% white
  static const Color textLight = Color(0xFF000000);
  
  static const Color error = Color(0xFFCF6679);
  static const Color success = Color(0xFF03DAC6); // Reusing secondary teal for success state
}

