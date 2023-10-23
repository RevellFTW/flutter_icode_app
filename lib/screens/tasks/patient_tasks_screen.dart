import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/patient_task.dart';

class TasksScreen extends StatelessWidget {
  final List<PatientTask> tasks;
  final String eventLogName;
  const TasksScreen(
      {super.key, required this.tasks, required this.eventLogName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(eventLogName),
          backgroundColor: appBackgroundColor,
          foregroundColor: appForegroundColor),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('[${tasks[index].date}]: ${tasks[index].name}'),
            subtitle: Text(tasks[index].description),
          );
        },
      ),
    );
  }
}
