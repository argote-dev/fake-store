import 'package:fake_store/common/utils/debouncer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Debouncer', () {
    test('should execute action only once after specified delay', () async {
      // Given
      final debouncer = Debouncer(milliseconds: 100);
      int counter = 0;
      
      // When
      debouncer.run(() => counter++);
      debouncer.run(() => counter++);
      debouncer.run(() => counter++);
      
      // Then
      expect(counter, 0); // Not executed yet
      
      await Future.delayed(const Duration(milliseconds: 150));
      expect(counter, 1); // Executed only once
    });

    test('should cancel previous timer when run again', () async {
      // Given
      final debouncer = Debouncer(milliseconds: 100);
      int counter = 0;
      
      // When
      debouncer.run(() => counter++);
      await Future.delayed(const Duration(milliseconds: 50));
      debouncer.run(() => counter++); // Resets timer
      
      await Future.delayed(const Duration(milliseconds: 70));
      expect(counter, 0); // Still shouldn't have executed (50+70=120 total, but only 70 since second call)
      
      await Future.delayed(const Duration(milliseconds: 50));
      expect(counter, 1);
    });

    test('dispose should cancel timer', () async {
      // Given
      final debouncer = Debouncer(milliseconds: 100);
      int counter = 0;
      
      // When
      debouncer.run(() => counter++);
      debouncer.dispose();
      
      // Then
      await Future.delayed(const Duration(milliseconds: 150));
      expect(counter, 0);
    });
  });
}
