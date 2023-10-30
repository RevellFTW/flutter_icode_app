import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../global/variables.dart';
import '../helper/firestore_helper.dart';
import '../models/patient.dart';
import '../models/event_log.dart';
import 'patient_care_tasks_screen.dart';
import 'tasks/patient_tasks_screen.dart';

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
  String currentTextFormFieldValue = '';
  Map<String, Map<String, String>> careTasks = {};
  final FocusNode _focusNode = FocusNode();

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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.patient.name);
    _startDateController =
        TextEditingController(text: widget.patient.startDate.toString());
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
                onChanged: (String newValue) {
                  setState(() {
                    currentTextFormFieldValue = newValue;
                  });
                },
                onFieldSubmitted: (String newValue) {
                  setState(() {
                    if (currentTextFormFieldValue.isNotEmpty) {
                      widget.patient.name = currentTextFormFieldValue;
                      modifyPatientInDb(widget.patient);
                    } else {
                      _nameController.text = widget.patient.name;
                    }
                  });
                },
                onTapOutside: (newValue) {
                  if (currentTextFormFieldValue.isNotEmpty) {
                    setState(() {
                      widget.patient.name = currentTextFormFieldValue;
                      modifyPatientInDb(widget.patient);
                    });
                  } else {
                    setState(() {
                      _nameController.text = widget.patient.name;
                    });
                  }
                  FocusScope.of(context).unfocus();
                },
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
                          builder: (context) =>
                              CareTasksPage(patient: widget.patient)));
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
