import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../models/patient_task.dart';
import 'tasks/patient_tasks_screen.dart';
import '../main.dart';

class PatientFormScreen extends StatefulWidget {
  final Patient patient;

  const PatientFormScreen({super.key, required this.patient});

  @override
  _PatientFormScreenState createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _startDateController;
  late TextEditingController _caretakerNameController;

  Future<List<PatientTask>> loadTasksFromFirestore() async {
    List<PatientTask> tasks = [];
    QuerySnapshot querySnapshot = await db.collection('patientTasks').get();

    for (var doc in querySnapshot.docs) {
      tasks.add(PatientTask(
        name: doc['name'],
        description: doc['description'],
        date: doc['date'].toDate(),
        caretakerName: doc['caretakerName'],
      ));
    }

    return tasks;
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.patient.name);
    _startDateController =
        TextEditingController(text: widget.patient.startDate.toString());
    _caretakerNameController =
        TextEditingController(text: widget.patient.caretakerName);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextFormField(
            controller: _startDateController,
            decoration: const InputDecoration(labelText: 'Start Date'),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: TextFormField(
              controller: _caretakerNameController,
              decoration: const InputDecoration(labelText: 'Caretaker'),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                List<PatientTask> tasks = await loadTasksFromFirestore();
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TasksScreen(tasks: tasks)),
                );
              }
            },
            child: const Text('View Tasks'),
          ),
        ],
      ),
    );
  }
}
