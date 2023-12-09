import 'package:flutter/material.dart';
import 'package:todoapp/helper/firestore_helper.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_theme.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_util.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_widgets.dart';
import 'package:todoapp/models/caretaker.dart';
import 'package:todoapp/models/event_log.dart';
import 'package:todoapp/models/patient.dart';
import 'package:todoapp/screens/home_page.dart';
import 'package:todoapp/widget/custom_app_bar.dart';

class EventLogFormScreen extends StatefulWidget {
  final EventLog eventLog;
  final Caller caller;
  final bool modifying;
  final Patient? patient;
  final Caretaker? caretaker;

  const EventLogFormScreen(
      {super.key,
      required this.eventLog,
      required this.caller,
      required this.modifying,
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

  late List<String> careTaskList = [];
  late Map<String, List<String>> individualCareTaskslistMap = {};
  late List<Caretaker> caretakerList = [];
  late List<Patient> patientList = [];

  @override
  void initState() {
    updatedDateTime = widget.eventLog.date;

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
          title: 'Back to Patient Doe\'s sheet',
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
                          items: widget.caller == Caller.patient
                              ? getTaskNameDropdownEntries()
                              : getTaskNameDropdownEntries(
                                  index: widget.patient!.id.toString()),
                          onChanged: (value) {
                            setState(() {
                              widget.eventLog.name = value.toString();
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
                              _nameController.text =
                                  widget.eventLog.description;
                            });
                            FocusScope.of(context).unfocus();
                          },
                          onFieldSubmitted: (String newValue) {
                            saveTextValue(currentDescriptionTextFormFieldValue,
                                _descriptionController, (value) {
                              widget.eventLog.description = value;
                            }, () {
                              _nameController.text =
                                  widget.eventLog.description;
                            });
                          },
                        ),
                        TextFormField(
                          onTap: () => updateStartDate(widget.eventLog.date),
                          //enabled: false,
                          keyboardType: TextInputType.datetime,
                          controller: _dateController,
                          // focusNode: _model.textFieldFocusNode2,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
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
                          setState(() {
                            if (!widget.modifying) {
                            } else {
                              //modify eventLog in db
                            }
                            Navigator.of(context).pop();
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
        });
        widget.eventLog.date = updatedDateTime;
        _dateController.text =
            "${updatedDateTime.day.toString().padLeft(2, '0')}/${updatedDateTime.month.toString().padLeft(2, '0')}/${updatedDateTime.year}";
      }
    }
  }

  List<DropdownMenuItem<String>> getTaskNameDropdownEntries({String? index}) {
    return widget.caller == Caller.patient
        ? careTaskList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
                value: value, child: const Text('value'));
          }).toList()
        : individualCareTaskslistMap[index]!
            .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
                value: value, child: const Text('value'));
          }).toList();
  }

  List<DropdownMenuItem<String>> getPersonTypeDropdownEntries() {
    return widget.caller == Caller.patient
        ? caretakerList.map<DropdownMenuItem<String>>((Caretaker value) {
            return DropdownMenuItem<String>(
                value: value.id.toString(), child: const Text('value.name'));
          }).toList()
        : patientList.map<DropdownMenuItem<String>>((Patient value) {
            return DropdownMenuItem<String>(
                value: value.id.toString(), child: const Text('value.name'));
          }).toList();
  }
}
