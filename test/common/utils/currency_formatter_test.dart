import 'package:fake_store/common/utils/currency_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurrencyFormatter', () {
    test('should format double value to COP currency string', () {
      // Given
      const double value = 150000;
      
      // When
      final result = CurrencyFormatter.formatCOP(value);
      
      // Then
      // es_CO locale with NumberFormat.currency usually produces "$150.000" or similar
      // Note: non-breaking space might be present depending on intl version/locale data
      expect(result.contains('\$'), true);
      expect(result.contains('150'), true);
      expect(result.contains('000'), true);
    });

    test('should format 0 correctly', () {
      // Given
      const double value = 0;
      
      // When
      final result = CurrencyFormatter.formatCOP(value);
      
      // Then
      expect(result.contains('0'), true);
    });
  });
}
