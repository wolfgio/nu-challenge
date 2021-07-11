import 'package:intl/intl.dart';

class CurrencyFormats {
  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: 'USD ');
    return formatter.format(amount);
  }
}
