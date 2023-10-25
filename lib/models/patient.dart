import 'care_task.dart';

class Patient {
  int id;
  String name;
  DateTime startDate;
  List<CareTask> careTasks;

  Patient({
    required this.id,
    required this.name,
    required this.startDate,
    required this.careTasks,
  });
}
