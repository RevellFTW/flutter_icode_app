import 'patient.dart';

class Caretaker {
  int id;
  String name;
  DateTime startDate;
  List<Patient> patients;

  Caretaker({
    required this.id,
    required this.name,
    required this.startDate,
    this.patients = const [],
  });
}
