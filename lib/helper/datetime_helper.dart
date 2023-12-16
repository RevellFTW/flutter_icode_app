import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/global/variables.dart';
import 'package:todoapp/models/care_task.dart';

DateTime setDateTime(int year, int month, int day, int hour, int minute) {
  return DateTime(year, month, day, hour, minute);
}

DateTime yMHTAStringToDateTime(String date) {
  DateTime dateTime = DateFormat("yyyy-MM-dd hh:mm a").parse(date);
  return dateTime;
}

TimeOfDay extractTimeFromInput(String input) {
  // Extracts time portion (e.g., "Wednesday 12:00 PM") from the input
  List<String> parts = input.split(' ');
  String timeString = '${parts[1]} ${parts[2]}';
  return stringToTimeOfDay(timeString);
}

TimeOfDay stringToTimeOfDay(String time) {
  // Split the input string into hours, minutes, and AM/PM parts
  List<String> parts = time.split(' ');
  List<String> timeParts = parts[0].split(':');
  int hours = int.parse(timeParts[0]);
  int minutes = int.parse(timeParts[1]);

  // Determine whether it's AM or PM and adjust hours accordingly
  if (parts[1] == 'PM' && hours != 12) {
    hours += 12;
  } else if (parts[1] == 'AM' && hours == 12) {
    hours = 0;
  }

  // Create and return the TimeOfDay object
  return TimeOfDay(hour: hours, minute: minutes);
}

//input is ike 12.10 12:00
DateTime mHTAStringToDateTime(String date) {
  // Parse the string to DateTime
  DateTime dateTime = DateFormat("MM-dd hh:mm a").parse(date);

  return dateTime;
}
