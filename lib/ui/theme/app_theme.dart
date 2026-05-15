import 'package:flutter/material.dart';

enum AppThemeMode { normal, express }

class AppTheme {
  // Colors Modo Normal
  static const Color primaryColorNormal = Color(0xFFFFe800);

  // Colors Mode Express
  static const Color primaryColorExpress = Color(0xFF2596be);

  static const Color secondaryColor = Color(0xFF000000);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF000000);

  final Brightness brightness;
  final AppThemeMode mode;

  AppTheme({
    this.brightness = Brightness.light,
    this.mode = AppThemeMode.normal,
  });

  Color get _primaryColor =>
      mode == AppThemeMode.normal ? primaryColorNormal : primaryColorExpress;

  ThemeData getTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: brightness,
      primary: _primaryColor,
      onPrimary: mode == AppThemeMode.normal ? Colors.black : Colors.white,
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
        backgroundColor: _primaryColor,
        foregroundColor: mode == AppThemeMode.normal
            ? Colors.black
            : Colors.white,
        iconTheme: IconThemeData(
          color: mode == AppThemeMode.normal ? Colors.black : Colors.white,
        ),
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
