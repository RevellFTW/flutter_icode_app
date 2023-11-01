import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/models/caretaker.dart';
import '../global/variables.dart';
import '../helper/firestore_helper.dart';
import '../models/event_log.dart';
import 'home_page.dart';
import 'tasks/event_log_screen.dart';

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
  String currentTextFormFieldValue = '';
  late DateTime updatedDateTime;

  Future<List<EventLog>> loadTasksFromFirestore(String caretakerId) async {
    List<EventLog> tasks = [];
    QuerySnapshot querySnapshot = await db.collection('patientTasks').get();

    for (var doc in querySnapshot.docs) {
      tasks.add(EventLog(
          id: doc['id'],
          name: doc['name'],
          description: doc['description'],
          date: doc['date'].toDate(),
          caretakerId: doc['caretakerId'],
          patientId: doc['patientId']));
    }

    return tasks
        .where((element) => element.caretakerId == caretakerId)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    updatedDateTime = widget.caretaker.startDate;
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
                onChanged: (String newValue) {
                  setState(() {
                    currentTextFormFieldValue = newValue;
                  });
                },
                onFieldSubmitted: (String newValue) {
                  setState(() {
                    if (currentTextFormFieldValue.isNotEmpty) {
                      widget.caretaker.name = currentTextFormFieldValue;
                      modifyCaretakerInDb(widget.caretaker);
                    } else {
                      _nameController.text = widget.caretaker.name;
                    }
                  });
                },
                onTapOutside: (newValue) {
                  if (currentTextFormFieldValue.isNotEmpty) {
                    setState(() {
                      widget.caretaker.name = currentTextFormFieldValue;
                      modifyCaretakerInDb(widget.caretaker);
                    });
                  } else {
                    setState(() {
                      _nameController.text = widget.caretaker.name;
                    });
                  }
                  FocusScope.of(context).unfocus();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FloatingActionButton.extended(
                      label: Text(
                        widget.caretaker.startDate.toString(),
                      ),
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () =>
                          updateStartDate(widget.caretaker.startDate)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      List<EventLog> tasks = await loadTasksFromFirestore(
                          widget.caretaker.id.toString());
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EventLogScreen(
                                eventLogs: tasks,
                                eventLogName:
                                    "${widget.caretaker.name} Caretaker's Log",
                                caller: Caller.caretaker,
                                caretaker: widget.caretaker,
                              )));
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

  Future<void> updateStartDate(DateTime time) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: time,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 100),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(pickedDate),
      );
      if (pickedTime != null) {
        setState(() {
          updatedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
        widget.caretaker.startDate = updatedDateTime;
        modifyCaretakerInDb(widget.caretaker);
      }
    }
  }
}
