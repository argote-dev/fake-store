import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatCOP(double value) {
    final formatter = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
      customPattern: '¤ #,##0',
    );
    return formatter.format(value);
  }
}
