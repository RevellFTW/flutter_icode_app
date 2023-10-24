import 'package:flutter/material.dart';

DateTime _selectedDateTime = DateTime.now();

Future<void> pickDate(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: _selectedDateTime,
    firstDate: DateTime(DateTime.now().year - 100),
    lastDate: DateTime(DateTime.now().year + 100),
  );
  if (pickedDate != null && pickedDate != _selectedDateTime) {
    _selectedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      _selectedDateTime.hour,
      _selectedDateTime.minute,
    );
  }
}

Future<void> pickTime(BuildContext context) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
  );
  if (pickedTime != null) {
    _selectedDateTime = DateTime(
      _selectedDateTime.year,
      _selectedDateTime.month,
      _selectedDateTime.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }
}
