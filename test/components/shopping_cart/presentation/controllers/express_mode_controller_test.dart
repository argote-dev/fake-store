import 'package:clock/clock.dart';
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

    test('shouldShowSwitcher should return true when hour is within express window (e.g., 12:00)', () {
      withClock(Clock.fixed(DateTime(2026, 5, 19, 12, 0)), () {
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

    test('shouldShowSwitcher should return false when hour is outside express window (e.g., 18:00)', () {
      withClock(Clock.fixed(DateTime(2026, 5, 19, 18, 0)), () {
        // Given
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final controller = container.read(expressModeProvider.notifier);

        // When
        final result = controller.shouldShowSwitcher;

        // Then
        expect(result, false);
      });
    });
  });
}
