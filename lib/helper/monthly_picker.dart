import 'package:flutter/material.dart';

class MonthlyPicker extends StatefulWidget {
  final DateTime initialDate;

  MonthlyPicker({required this.initialDate});

  @override
  _MonthlyPickerState createState() => _MonthlyPickerState();
}

class _MonthlyPickerState extends State<MonthlyPicker> {
  late DateTime _selectedDate;
  late int _selectedMonth;
  late int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _selectedMonth = _selectedDate.month;
    _selectedYear = _selectedDate.year;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Month and Day'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<int>(
                value: _selectedMonth,
                items: List.generate(12, (index) {
                  return DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text('${_getMonthName(index + 1)}'),
                  );
                }),
                onChanged: (value) {
                  setState(() {
                    _selectedMonth = value!;
                  });
                },
              ),
              _buildDayPicker(),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(_selectedDate);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildDayPicker() {
    int daysInMonth = DateTime(_selectedYear, _selectedMonth + 1, 0).day;
    return DropdownButton<int>(
      value: _selectedDate.day,
      items: List.generate(daysInMonth, (index) {
        return DropdownMenuItem<int>(
          value: index + 1,
          child: Text('${index + 1}'),
        );
      }),
      onChanged: (value) {
        setState(() {
          _selectedDate = DateTime(_selectedYear, _selectedMonth, value!);
        });
      },
    );
  }

  String _getMonthName(int month) {
    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
