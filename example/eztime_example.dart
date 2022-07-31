import 'package:eztime/eztime.dart';

void main() {
  var time1 = Time(10, 30, 15); // 10:30:15
  var time2 = Time(5, 15, 5); // 05:15:05
  print('$time1 + $time2 = ${time1 + time2}'); // 15:45:20
  print('$time1 - $time2 = ${time1 - time2}'); // 05:15:10
}
