import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/models/caretaker.dart';
import '../global/variables.dart';
import '../models/event_log.dart';
import 'tasks/patient_tasks_screen.dart';

class CaretakerFormScreen extends StatefulWidget {
  final Caretaker caretaker;

  const CaretakerFormScreen({super.key, required this.caretaker});

  @override
  // ignore: library_private_types_in_public_api
  _CaretakerFormScreenState createState() => _CaretakerFormScreenState();
}

class _CaretakerFormScreenState extends State<CaretakerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _startDateController;

  Future<List<EventLog>> loadTasksFromFirestore(String caretakerName) async {
    List<EventLog> tasks = [];
    QuerySnapshot querySnapshot = await db.collection('patientTasks').get();

    for (var doc in querySnapshot.docs) {
      tasks.add(EventLog(
        name: doc['name'],
        description: doc['description'],
        date: doc['date'].toDate(),
        caretakerName: doc['caretakerName'],
      ));
    }

    return tasks
        .where((element) => element.caretakerName == caretakerName)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.caretaker.name);
    _startDateController =
        TextEditingController(text: widget.caretaker.startDate.toString());
    //todo display patient list
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
                      List<EventLog> tasks =
                          await loadTasksFromFirestore(widget.caretaker.name);
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TasksScreen(
                              tasks: tasks,
                              eventLogName:
                                  "${widget.caretaker.name} Caretaker's Log")));
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
