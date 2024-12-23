import 'package:flutter/material.dart';

class AppColors {
  // --- Pastel & Playful Palette ---
  static const Color primaryColor = Color.fromARGB(255, 98, 180, 247); // Light Dusty Blue
  static const Color primaryLight = Color(0xFFD6E7F2); // Very Light Blue
  static const Color primaryDark = Color.fromARGB(255, 128, 166, 200); // Slightly Darker Blue

  static const Color white = Color.fromARGB(255, 255, 255, 255); // Slightly Darker Blue
  static const accentColor = Color.fromARGB(255, 236, 173, 96);
  static const Color accentLight = Color(0xFFF5E6D5); // Very Light Peach
  static const Color accentDark = Color.fromARGB(255, 174, 109, 30); // Slightly Darker Peach

  static const Color backgroundColor =Color.fromARGB(255, 233, 235, 212); // Very Light Gray/Off-White
  static const Color surfaceColor = Color(0xFFFFFFFF); // White
  static const Color textColor = Color.fromARGB(255, 255, 255, 255); // Muted Dark Gray

  static const Color gray = Color.fromARGB(255, 69, 69, 69); // Slightly Darker Blue
  static const Color errorColor = Color(0xFFD4938C); // Muted Pastel Red
  static const Color successColor = Color(0xFF9BC99E); // Muted Pastel Green
  static const Color warningColor = Color(0xFFEBD3A4); // Muted Pastel Yellow

  // Primary Swatch
  static const MaterialColor primarySwatch = MaterialColor(
    0xFFA6C4DC, // Light Dusty Blue
    <int, Color>{
      50: Color(0xFFEFF4F8),
      100: Color(0xFFD6E7F2),
      200: Color(0xFFBEDAEB),
      300: Color(0xFFACCFE5),
      400: Color(0xFF9EC7DF),
      500: Color(0xFFA6C4DC), // Same as primary
      600: Color(0xFF94B2CA),
      700: Color(0xFF82A0B7),
      800: Color(0xFF7592AB),
      900: Color(0xFF688498),
    },
  );
}
