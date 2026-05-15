import 'package:fake_store/components/shopping_cart/presentation/controllers/express_mode_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExpressModeController', () {
    test('initial state should be false', () {
      // Given
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // When
      final state = container.read(expressModeProvider);

      // Then
      expect(state, false);
    });

    test('toggle should change state', () {
      // Given
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final controller = container.read(expressModeProvider.notifier);

      // When
      controller.toggle(true);

      // Then
      expect(container.read(expressModeProvider), true);

      // When
      controller.toggle(false);

      // Then
      expect(container.read(expressModeProvider), false);
    });

    test('shouldShowSwitcher should return boolean value', () {
      // Given
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final controller = container.read(expressModeProvider.notifier);

      // When
      final result = controller.shouldShowSwitcher;

      // Then
      expect(result, true);
    });
  });
}
