import 'package:intl/intl.dart';

extension CommaFormat on num {
  String get withComma => NumberFormat('#,##0.00').format(this);
}
