import 'package:todoapp/models/caretaker.dart';
import 'package:todoapp/models/relative.dart';

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
  List<Caretaker>? assignedCaretakers = [];
  List<CareTask> careTasks;
  List<Relative> relatives = [];

  Patient(
      {required this.id,
      required this.name,
      required this.startDate,
      required this.dateOfBirth,
      required this.medicalState,
      required this.dailyHours,
      required this.takenMedicines,
      required this.allergies,
      required this.assignedCaretakers,
      required this.careTasks,
      required this.relatives});

  static Patient empty() {
    return Patient(
        id: 0,
        name: '',
        startDate: DateTime.now(),
        dateOfBirth: DateTime.now(),
        medicalState: '',
        dailyHours: 0,
        takenMedicines: '',
        allergies: '',
        assignedCaretakers: [],
        careTasks: [],
        relatives: []);
  }
}
