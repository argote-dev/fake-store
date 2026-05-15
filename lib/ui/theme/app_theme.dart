import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFFFe800);
  static const Color secondaryColor = Color(0xFF000000);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF000000);

  final Brightness brightness;

  AppTheme({this.brightness = Brightness.light});

  ThemeData getTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: brightness,
      primary: primaryColor,
      secondary: secondaryColor,
      surface: brightness == Brightness.light ? whiteColor : blackColor,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      cardTheme: CardThemeData(
        color: brightness == Brightness.light ? whiteColor : const Color(0xFF1E1E1E),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
  }
}
