import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_store/ui/theme/theme.dart';
import 'package:fake_store/components/shopping_cart/presentation/controllers/express_mode_controller.dart';

void main() {
  test('AppTheme returns correct colors for normal and express modes', () {
    final normalTheme = AppTheme(mode: AppThemeMode.normal).getTheme();
    final expressTheme = AppTheme(mode: AppThemeMode.express).getTheme();

    expect(normalTheme.colorScheme.primary, AppTheme.primaryColorNormal);
    expect(expressTheme.colorScheme.primary, AppTheme.primaryColorExpress);
  });

  test('appThemeProvider changes mode when expressModeProvider changes', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(appThemeProvider).mode, AppThemeMode.normal);

    container.read(expressModeProvider.notifier).toggle(true);
    expect(container.read(appThemeProvider).mode, AppThemeMode.express);

    container.read(expressModeProvider.notifier).toggle(false);
    expect(container.read(appThemeProvider).mode, AppThemeMode.normal);
  });
}
