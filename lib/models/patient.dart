import 'package:todoapp/models/caretaker.dart';

import 'care_task.dart';

class Patient {
  int id;
  String name;
  DateTime startDate;
  DateTime dateOfBirth;
  String medicalState;
  int dailyHours;
  String takenMedicines;
  String allergies;
  List<Caretaker>? assignedCaretakers;
  List<CareTask> careTasks;

  Patient({
    required this.id,
    required this.name,
    required this.startDate,
    required this.dateOfBirth,
    required this.medicalState,
    required this.dailyHours,
    required this.takenMedicines,
    required this.allergies,
    required this.assignedCaretakers,
    required this.careTasks,
  });
}
