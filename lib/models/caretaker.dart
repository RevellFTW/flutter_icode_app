import 'patient.dart';

class Caretaker {
  int id;
  String name;
  DateTime startDate;
  DateTime dateOfBirth;
  String email;
  String workTypes;
  String availability;
  List<Patient> patients;

  Caretaker({
    required this.id,
    required this.name,
    required this.startDate,
    required this.dateOfBirth,
    required this.email,
    required this.workTypes,
    required this.availability,
    this.patients = const [],
  });
}
