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
      onPrimary: Colors.black,
      secondary: secondaryColor,
      onSecondary: whiteColor,
      surface: brightness == Brightness.light
          ? whiteColor
          : const Color(0xFF121212),
      onSurface: brightness == Brightness.light ? blackColor : whiteColor,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      cardTheme: CardThemeData(
        color: brightness == Brightness.light
            ? whiteColor
            : const Color(0xFF1E1E1E),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      textTheme: TextTheme(
        headlineSmall: TextStyle(color: colorScheme.onSurface),
        titleSmall: TextStyle(color: colorScheme.onSurface),
        titleMedium: TextStyle(color: colorScheme.onSurface),
        bodySmall: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
