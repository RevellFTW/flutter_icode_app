import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/care_task.dart';
import '../models/patient.dart';
import '../models/event_log.dart';
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
  Map<String, Map<String, String>> careTasks = {};
  Future<List<EventLog>> loadEventLogsFromFirestore() async {
    List<EventLog> tasks = [];
    QuerySnapshot querySnapshot = await db
        .collection('patientTasks')
        .where('name', isEqualTo: widget.patient.name)
        .get();

    for (var doc in querySnapshot.docs) {
      tasks.add(EventLog(
        name: doc['name'],
        description: doc['description'],
        date: doc['date'].toDate(),
        caretakerName: doc['caretakerName'],
      ));
    }

    return tasks;
  }

  Future<Map<String, Map<String, String>>> loadCareTasksFromFirestore() async {
    Map<String, Map<String, String>> tasks = {};
    List<CareTask> careTasks = widget.patient.careTasks;

    for (int i = 0; i < careTasks.length; i++) {
      String taskName = careTasks[i].taskName;
      String frequencyName = careTasks[i].taskFrequency;
      tasks[i.toString()] = {
        'task': taskName,
        'frequency': frequencyName,
      };
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

  Future<Map<String, Map<String, String>>> _loadData() async {
    // Load the data asynchronously
    final data = await loadCareTasksFromFirestore();
    // Return the loaded data
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(appName),
          backgroundColor: appBackgroundColor,
          foregroundColor: appForegroundColor),
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30, top: 10),
        child: Form(
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CareTasksPage(
                              careTasks: careTasks, patient: widget.patient)));
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
                      List<EventLog> tasks = await loadEventLogsFromFirestore();
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TasksScreen(
                              tasks: tasks,
                              eventLogName:
                                  "${widget.patient.name} Patient's Log")));
                    }
                  },
                  child: const Text('Event Logs'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
