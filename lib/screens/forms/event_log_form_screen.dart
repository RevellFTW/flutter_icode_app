import 'package:flutter/material.dart';
import 'package:todoapp/global/variables.dart';
import 'package:todoapp/helper/datetime_helper.dart';
import 'package:todoapp/helper/firestore_helper.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_theme.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_util.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_widgets.dart';
import 'package:todoapp/models/caretaker.dart';
import 'package:todoapp/models/event_log.dart';
import 'package:todoapp/models/patient.dart';
import 'package:todoapp/screens/home_page.dart';
import 'package:todoapp/screens/tasks_and_logs/event_log_screen.dart';
import 'package:todoapp/widget/custom_app_bar.dart';

class EventLogFormScreen extends StatefulWidget {
  final EventLog eventLog;
  final Caller caller;
  final bool modifying;
  final List<String> careTaskList;
  final Map<String, List<String>> individualCareTaskslistMap;
  final List<Caretaker> caretakerList;
  final List<Patient> patientList;
  final Patient? patient;
  final Caretaker? caretaker;

  const EventLogFormScreen(
      {super.key,
      required this.eventLog,
      required this.caller,
      required this.modifying,
      required this.careTaskList,
      required this.individualCareTaskslistMap,
      required this.caretakerList,
      required this.patientList,
      this.patient,
      this.caretaker});

  @override
  // ignore: library_private_types_in_public_api
  _EventLogFormScreenState createState() => _EventLogFormScreenState();
}

class _EventLogFormScreenState extends State<EventLogFormScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;

  String currentNameTextFormFieldValue = '';
  String currentDescriptionTextFormFieldValue = '';
  String currentDateTextFormFieldValue = '';

  late DateTime updatedDateTime;

  List<DropdownMenuItem<String>> taskNames = [];
  List<DropdownMenuItem<String>> people = [];

  String backToText = '';
  String title = '';

  @override
  void initState() {
    updatedDateTime = yMHTAStringToDateTime(widget.eventLog.date);

    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _dateController = TextEditingController();
    if (widget.modifying) {
      setState(() {
        _nameController.text = widget.eventLog.name;
        _descriptionController.text = widget.eventLog.description;
      });
    }
    _dateController.text = widget.eventLog.date.toString();
    taskNames = widget.caller == Caller.patient
        ? getTaskNameDropdownEntries()
        : getTaskNameDropdownEntries(index: widget.patient!.id.toString());
    people = getPersonTypeDropdownEntries();

    widget.eventLog.name = taskNames.first.value!;

    if (widget.caller == Caller.patient) {
      backToText = "Back to ${widget.patient!.name} Patient's Log";
      title = "${widget.patient!.name} Patient's Log";
      widget.eventLog.patient = widget.patient!;
    } else if (widget.caller == Caller.caretaker) {
      backToText = "Back to ${widget.caretaker!.name} Caretaker's Log";
      title = "${widget.caretaker!.name} Caretaker's Log";
      widget.eventLog.caretaker = widget.caretaker!;
    }
  }

  Future<List<Patient>> _loadPatientData() async {
    // Load the data asynchronously
    final data = await loadPatientsFromFirestore();

    // Return the loaded data
    return data;
  }

  Future<List<String>> _loadCaretasks(String patientId) async {
    // Load the data asynchronously
    final data = await getCareTaskNamesFromPatientId(patientId);

    // Return the loaded data
    return data;
  }

  Future<List<Caretaker>> _loadCaretakerData() async {
    // Load the data asynchronously
    final data = await loadCaretakersFromFirestore();

    // Return the loaded data
    return data;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: CustomAppBar(
          title: backToText,
          onBackPressed: () async {
            if (widget.caller == Caller.patient) {
              List<EventLog> eventLogs = await loadEventLogsFromFirestore(
                  widget.patient!.id, widget.caller);
              Navigator.of(context).pop(MaterialPageRoute(
                  builder: (context) => EventLogScreen(
                        eventLogs: eventLogs,
                        eventLogName: "${widget.patient!.name} Patient's Log",
                        caller: Caller.patient,
                        patient: widget.patient,
                        caretaker: widget.caretaker,
                      )));
            } else {
              List<EventLog> eventLogs = await loadEventLogsFromFirestore(
                  widget.caretaker!.id, widget.caller);
              Navigator.of(context).pop(MaterialPageRoute(
                  builder: (context) => EventLogScreen(
                        eventLogs: eventLogs,
                        eventLogName:
                            "${widget.caretaker!.name} Caretaker's Log",
                        caller: Caller.caretaker,
                        patient: widget.patient,
                        caretaker: widget.caretaker,
                      )));
            }
          },
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(-1.00, 0.00),
                          child: Text(
                            'Add new eventLog',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        DropdownButtonFormField(
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle:
                                FlutterFlowTheme.of(context).labelMedium,
                            hintStyle: FlutterFlowTheme.of(context).labelMedium,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          value: taskNames.first.value,
                          items: taskNames,
                          onChanged: (value) {
                            setState(() {
                              widget.eventLog.name = value.toString();
                              if (widget.modifying) {
                                modifyEventLogInDb(widget.eventLog);
                              }
                            });
                          },
                        ),
                        DropdownButtonFormField(
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: widget.caller == Caller.patient
                                ? 'Caretaker'
                                : 'Patient',
                            labelStyle:
                                FlutterFlowTheme.of(context).labelMedium,
                            hintStyle: FlutterFlowTheme.of(context).labelMedium,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          value: people.first.value,
                          items: people,
                          onChanged: (value) {
                            setState(() {
                              if (widget.caller == Caller.patient) {
                                widget.eventLog.caretaker = widget.caretakerList
                                    .firstWhere((element) =>
                                        element.id.toString() == value);
                              } else {
                                widget.eventLog.patient = widget.patientList
                                    .firstWhere((element) =>
                                        element.id.toString() == value);
                                taskNames = getTaskNameDropdownEntries(
                                    index: value.toString());
                                widget.eventLog.name = taskNames.first.value!;
                              }
                              if (widget.modifying) {
                                modifyEventLogInDb(widget.eventLog);
                              }
                            });
                          },
                        ),
                        TextFormField(
                          controller: _descriptionController,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle:
                                FlutterFlowTheme.of(context).labelMedium,
                            hintStyle: FlutterFlowTheme.of(context).labelMedium,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          onChanged: (String newValue) {
                            setState(() {
                              currentDescriptionTextFormFieldValue = newValue;
                            });
                          },
                          onTapOutside: (newValue) {
                            saveTextValue(currentDescriptionTextFormFieldValue,
                                _descriptionController, (value) {
                              widget.eventLog.description = value;
                            }, () {
                              _descriptionController.text =
                                  widget.eventLog.description;
                            });
                            FocusScope.of(context).unfocus();
                          },
                          onFieldSubmitted: (String newValue) {
                            saveTextValue(currentDescriptionTextFormFieldValue,
                                _descriptionController, (value) {
                              widget.eventLog.description = value;
                            }, () {
                              _descriptionController.text =
                                  widget.eventLog.description;
                            });
                          },
                        ),
                        TextFormField(
                          key: Key(_dateController.text),
                          onTap: () async {
                            if (widget.modifying) {
                              await updateStartDate(
                                  yMHTAStringToDateTime(widget.eventLog.date));
                            } else {
                              await isDateUpdated(updatedDateTime);
                            }
                          },
                          keyboardType: TextInputType.datetime,
                          controller: _dateController,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Date',
                            labelStyle:
                                FlutterFlowTheme.of(context).labelMedium,
                            hintStyle: FlutterFlowTheme.of(context).labelMedium,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ].divide(const SizedBox(height: 12)),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0.00, 0.00),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 34, 0, 12),
                      child: FFButtonWidget(
                        onPressed: () {
                          setState(() async {
                            if (!widget.modifying) {
                              widget.caller == Caller.caretaker
                                  ? widget.eventLog.caretaker =
                                      widget.caretaker!
                                  : widget.eventLog.patient = widget.patient!;
                              if (widget.eventLog.name == 'Other' &&
                                  widget.eventLog.description.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please enter a description for the task.'),
                                  ),
                                );
                                return;
                              }
                              addEventLogInDb(widget.eventLog);
                            } else {
                              deleteEventLogFromFireStore(widget.eventLog);
                            }
                            List<EventLog> tasks =
                                widget.caller == Caller.patient
                                    ? await loadEventLogsFromFirestore(
                                        widget.patient!.id, widget.caller)
                                    : await loadEventLogsFromFirestore(
                                        widget.caretaker!.id, widget.caller);
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EventLogScreen(
                                      eventLogs: tasks,
                                      eventLogName: widget.caller ==
                                              Caller.patient
                                          ? "${widget.patient!.name} Patient's Log"
                                          : "${widget.caretaker!.name} Caretaker's Log",
                                      caller: Caller.patient,
                                      patient: widget.patient,
                                      caretaker: widget.caretaker,
                                    )));
                          });
                        },
                        text: widget.modifying ? 'DELETE' : 'ADD',
                        options: FFButtonOptions(
                          width: 600,
                          height: 48,
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: widget.modifying
                              ? const Color(0xFFEFEFEF)
                              : FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Readex Pro',
                                    color: widget.modifying
                                        ? const Color(0xFFFF0800)
                                        : Colors.white,
                                  ),
                          elevation: 4,
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void saveTextValue(String currentFieldValue, TextEditingController controller,
      Function setAttribute, Function setControllerText) {
    if (currentFieldValue.isNotEmpty) {
      setState(() {
        setAttribute(currentFieldValue);
        if (widget.modifying) modifyEventLogInDb(widget.eventLog);
      });
    } else {
      setState(() {
        setControllerText();
      });
    }
  }

  Future<void> updateStartDate(DateTime time) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: time,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 100),
    );
    if (pickedDate != null) {
      // ignore: use_build_context_synchronously
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
          widget.eventLog.date =
              DateFormat('yyyy-MM-dd h:mm a').format(updatedDateTime);
          setState(() {
            _dateController.text = widget.eventLog.date;
          });

          modifyEventLogInDb(widget.eventLog);
        });
      }
    }
  }

  Future<bool> isDateUpdated(DateTime time) async {
    // For once, pick date and time
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: time,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 100),
    );
    if (pickedDate != null) {
      // ignore: use_build_context_synchronously
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(pickedDate),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateFormat('yyyy-MM-dd h:mm a').format(DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          ));
          selectedDateTimeWhenAdding = selectedDateTime;
          updatedDateTime = yMHTAStringToDateTime(selectedDateTime);
          _dateController.text = selectedDateTime;
          widget.eventLog.date =
              DateFormat('yyyy-MM-dd h:mm a').format(DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          ));
        });
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  List<DropdownMenuItem<String>> getTaskNameDropdownEntries({String? index}) {
    return widget.caller == Caller.patient
        ? widget.careTaskList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList()
        : widget.individualCareTaskslistMap[index]!
            .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList();
  }

  List<DropdownMenuItem<String>> getPersonTypeDropdownEntries() {
    return widget.caller == Caller.patient
        ? widget.caretakerList.map<DropdownMenuItem<String>>((Caretaker value) {
            return DropdownMenuItem<String>(
                value: value.id.toString(), child: Text(value.name));
          }).toList()
        : widget.patientList.map<DropdownMenuItem<String>>((Patient value) {
            return DropdownMenuItem<String>(
                value: value.id.toString(), child: Text(value.name));
          }).toList();
  }
}
