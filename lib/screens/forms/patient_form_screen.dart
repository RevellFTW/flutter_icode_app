import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_icon_button.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_theme.dart';
import '../../global/variables.dart';
import '../../helper/firestore_helper.dart';
import '../../models/patient.dart';
import '../../models/event_log.dart';
import '../home_page.dart';
import '../tasks_and_logs/patient_care_tasks_screen.dart';
import '../tasks_and_logs/event_log_screen.dart';

class PatientFormScreen extends StatefulWidget {
  final Patient patient;

  const PatientFormScreen({super.key, required this.patient});

  @override
  _PatientFormScreenState createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  String currentTextFormFieldValue = '';
  Map<String, Map<String, String>> careTasks = {};
  late DateTime updatedDateTime;

  Future<List<EventLog>> loadEventLogsFromFirestore() async {
    List<EventLog> tasks = [];
    QuerySnapshot querySnapshot = await db
        .collection('patientTasks')
        .where('patientId', isEqualTo: widget.patient.id.toString())
        .get();

    for (var doc in querySnapshot.docs) {
      tasks.add(EventLog(
          id: doc['id'],
          name: doc['name'],
          description: doc['description'],
          date: doc['date'].toDate(),
          caretakerId: doc['caretakerId'],
          patientId: doc['patientId']));
    }

    return tasks;
  }

  @override
  void initState() {
    super.initState();
    updatedDateTime = widget.patient.startDate;
    _nameController = TextEditingController(text: widget.patient.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBackgroundColor,
        foregroundColor: appForegroundColor,
        automaticallyImplyLeading: false,
        actions: [],
        flexibleSpace: FlexibleSpaceBar(
          title: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 14),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: Align(
                          alignment: const AlignmentDirectional(0.00, 0.00),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                4, 0, 0, 0),
                            child: Text(
                              'CuramusApp',
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    fontFamily: 'Outfit',
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                        child: FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 30,
                          borderWidth: 1,
                          buttonSize: 50,
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () async {
                            //context.pop();
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                        child: Text(
                          'Back to Curamus Back-Office',
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                                fontFamily: 'Outfit',
                                color: Colors.white,
                                fontSize: 16,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
          expandedTitleScale: 1.0,
        ),
        elevation: 2,
      ),
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
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FloatingActionButton.extended(
                      label: Text(
                        DateFormat('yyyy-MM-dd – kk:mm')
                            .format(widget.patient.startDate)
                            .toString(),
                      ),
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () =>
                          updateStartDate(widget.patient.startDate)),
                ),
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
                          builder: (context) => EventLogScreen(
                                eventLogs: tasks,
                                eventLogName:
                                    "${widget.patient.name} Patient's Log",
                                caller: Caller.patient,
                                patient: widget.patient,
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
        widget.patient.startDate = updatedDateTime;
        modifyPatientInDb(widget.patient);
      }
    }
  }
}
