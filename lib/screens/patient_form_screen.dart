import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../models/patient_task.dart';
import 'patient_care_tasks_screen.dart';
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
  List<String> careTasks = [];
  Future<List<PatientTask>> loadEventLogsFromFirestore() async {
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

  Future<List<String>> loadCareTasksFromFirestore() async {
    List<String> tasks = [];
    QuerySnapshot querySnapshot = await db
        .collection('patients')
        .where('id', isEqualTo: widget.patient.id)
        .get();

    for (var task in querySnapshot.docs[0]['careTasks']) {
      tasks.add(task.toString());
    }
    return tasks;
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.patient.name);
    _startDateController =
        TextEditingController(text: widget.patient.startDate.toString());
    _loadData().then((value) {
      setState(() {
        careTasks = value;
      });
    });
  }

  Future<List<String>> _loadData() async {
    // Load the data asynchronously
    final data = await loadCareTasksFromFirestore();
    // Return the loaded data
    return data;
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
            padding: const EdgeInsets.only(top: 30.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CareTasksPage(careTasks: careTasks)),
                  );
                }
              },
              child: const Text('Care Tasks'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  List<PatientTask> tasks = await loadEventLogsFromFirestore();
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TasksScreen(tasks: tasks)),
                  );
                }
              },
              child: const Text('Event Logs'),
            ),
          ),
        ],
      ),
    );
  }
}
