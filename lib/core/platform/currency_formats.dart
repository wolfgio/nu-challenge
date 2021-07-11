import 'package:intl/intl.dart';

class CurrencyFormats {
  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency();
    return formatter.format(amount);
  }
}
