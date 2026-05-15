import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_theme.dart';
import 'package:fake_store/components/shopping_cart/presentation/controllers/express_mode_controller.dart';

class AppThemeState {
  final AppThemeMode mode;
  final Brightness brightness;

  AppThemeState({
    required this.mode,
    required this.brightness,
  });

  AppThemeState copyWith({
    AppThemeMode? mode,
    Brightness? brightness,
  }) {
    return AppThemeState(
      mode: mode ?? this.mode,
      brightness: brightness ?? this.brightness,
    );
  }
}

class AppThemeNotifier extends Notifier<AppThemeState> {
  @override
  AppThemeState build() {
    // Escuchamos el expressModeProvider para cambiar el modo automáticamente
    final isExpress = ref.watch(expressModeProvider);
    
    return AppThemeState(
      mode: isExpress ? AppThemeMode.express : AppThemeMode.normal,
      brightness: Brightness.light, // Podríamos persistir esto luego
    );
  }

  void setBrightness(Brightness brightness) {
    state = state.copyWith(brightness: brightness);
  }
}

final appThemeProvider = NotifierProvider<AppThemeNotifier, AppThemeState>(() {
  return AppThemeNotifier();
});
