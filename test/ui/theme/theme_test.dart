import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_store/ui/theme/theme.dart';
import 'package:fake_store/components/shopping_cart/presentation/controllers/express_mode_controller.dart';

void main() {
  test('AppTheme returns correct colors for normal and express modes', () {
    // Given
    final normalTheme = AppTheme(mode: AppThemeMode.normal).getTheme();
    final expressTheme = AppTheme(mode: AppThemeMode.express).getTheme();

    // Then
    expect(normalTheme.colorScheme.primary, AppTheme.primaryColorNormal);
    expect(expressTheme.colorScheme.primary, AppTheme.primaryColorExpress);
  });

  test('appThemeProvider changes mode when expressModeProvider changes', () {
    // Given
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(appThemeProvider).mode, AppThemeMode.normal);

    // When
    container.read(expressModeProvider.notifier).toggle(true);
    
    // Then
    expect(container.read(appThemeProvider).mode, AppThemeMode.express);

    // When
    container.read(expressModeProvider.notifier).toggle(false);
    
    // Then
    expect(container.read(appThemeProvider).mode, AppThemeMode.normal);
  });
}
