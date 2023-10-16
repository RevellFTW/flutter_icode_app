import 'package:flutter/material.dart';

import '../../models/patient_task.dart';

class TasksScreen extends StatelessWidget {
  final List<PatientTask> tasks;

  const TasksScreen({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Logs')),
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
