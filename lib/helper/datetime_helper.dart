import 'package:intl/intl.dart';

DateTime setDateTime(int year, int month, int day, int hour, int minute) {
  return DateTime(year, month, day, hour, minute);
}

DateTime yMHTAStringToDateTime(String date) {
  DateTime dateTime = DateFormat("yyyy-MM-dd hh:mm a").parse(date);
  return dateTime;
}
