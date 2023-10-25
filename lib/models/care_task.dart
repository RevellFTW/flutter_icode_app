import 'package:cloud_firestore/cloud_firestore.dart';

class CareTask {
  CareTask(
      {required this.taskName,
      required this.taskFrequency,
      required this.date});

  late String taskName;
  late Frequency taskFrequency;
  late DateTime date;

  factory CareTask.fromJson(Map<String, dynamic> json) {
    return CareTask(
      taskName: json['task'],
      taskFrequency: json['frequency'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['task'] = taskName;
    data['frequency'] = taskFrequency.name.toString();
    data['date'] = date;
    return data;
  }
}

enum Frequency { daily, weekly, monthly, once }
