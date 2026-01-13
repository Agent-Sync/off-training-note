import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFFF3F4F6); // gray-100 ish
  static const Color surface = Colors.white;
  static const Color primary = Colors.black;
  static const Color textMain = Color(0xFF111827); // gray-900
  static const Color textSecondary = Color(0xFF6B7280); // gray-500
  static const Color textHint = Color(0xFF9CA3AF); // gray-400
  
  static const Color focusColor = Color(0xFF2563EB); // blue-600
  static const Color outcomeColor = Color(0xFF16A34A); // green-600

  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      fontFamily: 'Hiragino Sans', // Default iOS font usually works, but good to specify if needed
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.black,
        surface: surface,
        background: background,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: textMain,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
