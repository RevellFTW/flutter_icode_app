import 'package:intl/intl.dart';
import 'package:todoapp/models/caretaker.dart';
import 'package:todoapp/models/patient.dart';

class EventLog {
  EventLog(
      {required this.id,
      required this.name,
      required this.description,
      required this.date,
      required this.caretaker,
      required this.patient});

  EventLog.empty(this.id, Caretaker caretakerParam, Patient patientParam)
      : name = '',
        description = '',
        date = DateFormat('yyyy-MM-dd h:mm a').format(DateTime.now()),
        caretaker = caretakerParam,
        patient = patientParam;

  final int id;
  String name;
  String description;
  String date;
  Caretaker caretaker;
  Patient patient;
}
