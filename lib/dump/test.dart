import 'package:intl/intl.dart';

void main() {
  var now = new DateTime.now();
  print(now.toString());
  print(DateFormat.jm().format(DateTime.now()));
}