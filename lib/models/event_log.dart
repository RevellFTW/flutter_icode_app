import 'package:intl/intl.dart';

class EventLog {
  EventLog(
      {required this.id,
      required this.name,
      required this.description,
      required this.date,
      required this.caretakerId,
      required this.patientId});

  EventLog.empty()
      : id = 0,
        name = '',
        description = '',
        date = DateFormat('yyyy-MM-dd h:mm a').format(DateTime.now()),
        caretakerId = '',
        patientId = '';

  final int id;
  String name;
  String description;
  String date;
  String? caretakerId;
  String? patientId;
}
