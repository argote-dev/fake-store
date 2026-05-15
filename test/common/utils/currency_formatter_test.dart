import 'package:fake_store/common/utils/currency_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurrencyFormatter', () {
    test('should format double value to COP currency string with space and dots', () {
      // Given
      const double value = 150000;
      
      // When
      final result = CurrencyFormatter.formatCOP(value);
      
      // Then
      expect(result, equals('\$ 150.000'));
    });

    test('should format 1000 correctly', () {
      // Given
      const double value = 1000;
      
      // When
      final result = CurrencyFormatter.formatCOP(value);
      
      // Then
      expect(result, equals('\$ 1.000'));
    });

    test('should format 0 correctly', () {
      // Given
      const double value = 0;
      
      // When
      final result = CurrencyFormatter.formatCOP(value);
      
      // Then
      expect(result, equals('\$ 0'));
    });
  });
}
