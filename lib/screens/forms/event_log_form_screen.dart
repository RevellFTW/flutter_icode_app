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

  late final DateTime updatedDateTime;

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
        _dateController.text = widget.eventLog.date.toString();
      });
    }
    taskNames = widget.caller == Caller.patient
        ? getTaskNameDropdownEntries()
        : getTaskNameDropdownEntries(index: widget.patient!.id.toString());
    people = getPersonTypeDropdownEntries();

    if (widget.caller == Caller.patient) {
      backToText = "Back to ${widget.patient!.name} Patient's Log";
      title = "${widget.patient!.name} Patient's Log";
      widget.eventLog.patientId = widget.patient!.id.toString();
    } else if (widget.caller == Caller.caretaker) {
      backToText = "Back to ${widget.caretaker!.name} Caretaker's Log";
      title = "${widget.caretaker!.name} Caretaker's Log";
      widget.eventLog.caretakerId = widget.caretaker!.id.toString();
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
          //todo make patient name dynamic
          title: backToText,
          onBackPressed: () async {
            Navigator.of(context).pop();
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
                            if (widget.caller == Caller.patient &&
                                value != widget.caretaker!.id.toString()) {
                              widget.eventLog.caretakerId = value.toString();
                            } else if (value != widget.patient!.id.toString()) {
                              widget.eventLog.patientId = value.toString();
                            }
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
                          onTap: () => widget.modifying
                              ? updateStartDate(
                                  yMHTAStringToDateTime(widget.eventLog.date))
                              : isDateUpdated(),
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
                          validator: (value) {
                            String pattern = r'^\d{2}/\d{2}/\d{4}$';
                            RegExp regex = RegExp(pattern);
                            if (!regex.hasMatch(value!)) {
                              return 'Invalid date format';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (String newValue) {
                            setState(() {
                              currentDateTextFormFieldValue = newValue;
                            });
                          },
                          onTapOutside: (newValue) {
                            saveTextValue(
                                currentDateTextFormFieldValue, _dateController,
                                (value) {
                              widget.eventLog.date = value;
                            }, () {
                              _dateController.text =
                                  widget.eventLog.date.toString();
                            });
                            FocusScope.of(context).unfocus();
                          },
                          onFieldSubmitted: (String newValue) {
                            saveTextValue(
                                currentDateTextFormFieldValue, _dateController,
                                (value) {
                              widget.eventLog.date = value;
                            }, () {
                              _dateController.text =
                                  widget.eventLog.date.toString();
                            });
                          },
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
                              addEventLogInDb(widget.eventLog);
                            } else {
                              deleteEventLogFromFireStore(widget.eventLog);
                            }
                            List<EventLog> tasks =
                                await loadEventLogsFromFirestore(
                                    widget.patient!.id);
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EventLogScreen(
                                      eventLogs: tasks,
                                      eventLogName:
                                          "${widget.patient!.name} Patient's Log",
                                      caller: Caller.patient,
                                      patient: widget.patient,
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
          _dateController.text =
              "${updatedDateTime.day.toString().padLeft(2, '0')}/${updatedDateTime.month.toString().padLeft(2, '0')}/${updatedDateTime.year}";
        });
      }
    }
  }

  Future<bool> isDateUpdated() async {
    // For once, pick date and time
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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

          // if (index != -1) {
          //   widget.patient.careTasks[index].date = selectedDateTime;
          //   _dateController.text = selectedDateTime;
          //   saveToDb();
          // }
          selectedDateTimeWhenAdding = selectedDateTime;
          _dateController.text =
              yMHTAStringToDateTime(selectedDateTime).toString();
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
