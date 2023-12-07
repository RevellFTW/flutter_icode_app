import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_count_controller.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_drop_down.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_theme.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_util.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_widgets.dart';
import 'package:todoapp/models/relative.dart';
import 'package:todoapp/widget/custom_app_bar.dart';
import '../../global/variables.dart';
import '../../helper/firestore_helper.dart';
import '../../models/patient.dart';
import '../../models/event_log.dart';
import '../home_page.dart';
import '../tasks_and_logs/patient_care_tasks_screen.dart';
import '../tasks_and_logs/event_log_screen.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import '../../models/patient_form_model.dart';
import 'relative_form_screen.dart';
export '../../models/patient_form_model.dart';

class PatientFormScreen extends StatefulWidget {
  final Patient patient;
  final List<Relative> relatives;
  const PatientFormScreen(
      {super.key, required this.patient, required this.relatives});

  @override
  // ignore: library_private_types_in_public_api
  _PatientFormScreenState createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _medicalStateController;
  late TextEditingController _takenMedicinesController;
  late TextEditingController _allergiesController;
  final _dateController = MaskedTextController(mask: '00/00/0000');
  String currentNameTextFormFieldValue = '';
  String currentMedicalStateTextFormFieldValue = '';
  String currentTakenMedicinesTextFormFieldValue = '';
  String currentAllergiesTextFormFieldValue = '';
  Map<String, Map<String, String>> careTasks = {};
  late DateTime updatedDateTime;
  late PatientFormModel _model;

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
    _model = createModel(context, () => PatientFormModel());
    updatedDateTime = widget.patient.startDate;
    _nameController = TextEditingController(text: widget.patient.name);
    _dateController.text =
        "${widget.patient.dateOfBirth.day.toString().padLeft(2, '0')}/${widget.patient.dateOfBirth.month.toString().padLeft(2, '0')}/${widget.patient.dateOfBirth.year}";
    _medicalStateController =
        TextEditingController(text: widget.patient.medicalState);
    _takenMedicinesController =
        TextEditingController(text: widget.patient.takenMedicines);
    _allergiesController =
        TextEditingController(text: widget.patient.allergies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Back to Curamus Back-Office',
        onBackPressed: () async {
          Navigator.of(context).pop();
        },
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: const AlignmentDirectional(-1.00, 0.00),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: Text(
                      'Patient Doe\'s sheet',
                      style:
                          FlutterFlowTheme.of(context).headlineMedium.override(
                                fontFamily: 'Outfit',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(-1.00, 0.00),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 12),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CareTasksPage(
                                          patient: widget.patient)));
                                },
                                text: 'Care Tasks',
                                options: FFButtonOptions(
                                  width: 150,
                                  height: 48,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  iconPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
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
                          Flexible(
                            child: Align(
                              alignment: const AlignmentDirectional(1.00, 0.00),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 12),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    List<EventLog> tasks =
                                        await loadEventLogsFromFirestore();
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EventLogScreen(
                                                  eventLogs: tasks,
                                                  eventLogName:
                                                      "${widget.patient.name} Patient's Log",
                                                  caller: Caller.patient,
                                                  patient: widget.patient,
                                                )));
                                  },
                                  text: 'Event Logs',
                                  options: FFButtonOptions(
                                    width: 150,
                                    height: 48,
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                    iconPadding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                    color: FlutterFlowTheme.of(context).primary,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
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
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: _nameController,
                        focusNode: _model.textFieldFocusNode1,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
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
                        onChanged: (String newValue) {
                          setState(() {
                            currentNameTextFormFieldValue = newValue;
                          });
                        },
                        onTapOutside: (newValue) {
                          if (currentNameTextFormFieldValue.isNotEmpty) {
                            setState(() {
                              widget.patient.name =
                                  currentNameTextFormFieldValue;
                              modifyPatientInDb(widget.patient);
                            });
                          } else {
                            setState(() {
                              _nameController.text = widget.patient.name;
                            });
                          }
                          FocusScope.of(context).unfocus();
                        },
                        onFieldSubmitted: (String newValue) {
                          setState(() {
                            if (currentNameTextFormFieldValue.isNotEmpty) {
                              widget.patient.name =
                                  currentNameTextFormFieldValue;
                              modifyPatientInDb(widget.patient);
                            } else {
                              _nameController.text = widget.patient.name;
                            }
                          });
                        },
                        style: FlutterFlowTheme.of(context).bodyMedium,
                        // validator: _model.textFieldController1Validator!
                        //     .asValidator(context),
                      ),
                      TextFormField(
                        onTap: () =>
                            updateStartDate(widget.patient.dateOfBirth),
                        //enabled: false,
                        keyboardType: TextInputType.datetime,
                        controller: _dateController,
                        focusNode: _model.textFieldFocusNode2,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
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
                      TextFormField(
                        controller: _medicalStateController,
                        focusNode: _model.textFieldFocusNode3,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Medical State',
                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
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
                            currentMedicalStateTextFormFieldValue = newValue;
                          });
                        },
                        onTapOutside: (newValue) {
                          if (currentMedicalStateTextFormFieldValue
                              .isNotEmpty) {
                            setState(() {
                              widget.patient.medicalState =
                                  currentMedicalStateTextFormFieldValue;
                              modifyPatientInDb(widget.patient);
                            });
                          } else {
                            setState(() {
                              _medicalStateController.text =
                                  widget.patient.medicalState;
                            });
                          }
                          FocusScope.of(context).unfocus();
                        },
                        onFieldSubmitted: (String newValue) {
                          setState(() {
                            if (currentMedicalStateTextFormFieldValue
                                .isNotEmpty) {
                              widget.patient.medicalState =
                                  currentMedicalStateTextFormFieldValue;
                              modifyPatientInDb(widget.patient);
                            } else {
                              _medicalStateController.text =
                                  widget.patient.medicalState;
                            }
                          });
                        },
                        // validator: _model.textFieldController3Validator
                        //     .asValidator(context),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 0, 0, 0),
                            child: Text(
                              'Daily hours ',
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ),
                          Flexible(
                            child: Align(
                              alignment: const AlignmentDirectional(1.00, 0.00),
                              child: Container(
                                width: 160,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(8),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 2,
                                  ),
                                ),
                                child: FlutterFlowCountController(
                                  decrementIconBuilder: (enabled) => FaIcon(
                                    FontAwesomeIcons.minus,
                                    color: enabled
                                        ? FlutterFlowTheme.of(context)
                                            .secondaryText
                                        : FlutterFlowTheme.of(context)
                                            .alternate,
                                    size: 20,
                                  ),
                                  incrementIconBuilder: (enabled) => FaIcon(
                                    FontAwesomeIcons.plus,
                                    color: enabled
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context)
                                            .alternate,
                                    size: 20,
                                  ),
                                  countBuilder: (count) => Text(
                                    count.toString(),
                                    style:
                                        FlutterFlowTheme.of(context).titleLarge,
                                  ),
                                  count: widget.patient.dailyHours ??= 0,
                                  updateCount: (count) => {
                                    setState(() =>
                                        widget.patient.dailyHours = count),
                                    modifyPatientInDb(widget.patient)
                                  },
                                  stepSize: 1,
                                  minimum: 1,
                                  maximum: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: _takenMedicinesController,
                        focusNode: _model.textFieldFocusNode4,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Taken medicines',
                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
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
                            currentTakenMedicinesTextFormFieldValue = newValue;
                          });
                        },
                        onTapOutside: (newValue) {
                          if (currentTakenMedicinesTextFormFieldValue
                              .isNotEmpty) {
                            setState(() {
                              widget.patient.takenMedicines =
                                  currentTakenMedicinesTextFormFieldValue;
                              modifyPatientInDb(widget.patient);
                            });
                          } else {
                            setState(() {
                              _takenMedicinesController.text =
                                  widget.patient.takenMedicines;
                            });
                          }
                          FocusScope.of(context).unfocus();
                        },
                        onFieldSubmitted: (String newValue) {
                          setState(() {
                            if (currentTakenMedicinesTextFormFieldValue
                                .isNotEmpty) {
                              widget.patient.takenMedicines =
                                  currentTakenMedicinesTextFormFieldValue;
                              modifyPatientInDb(widget.patient);
                            } else {
                              _takenMedicinesController.text =
                                  widget.patient.takenMedicines;
                            }
                          });
                        },
                      ),
                      TextFormField(
                        controller: _allergiesController,
                        focusNode: _model.textFieldFocusNode5,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Allergies',
                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
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
                            currentAllergiesTextFormFieldValue = newValue;
                          });
                        },
                        onTapOutside: (newValue) {
                          if (currentAllergiesTextFormFieldValue.isNotEmpty) {
                            setState(() {
                              widget.patient.allergies =
                                  currentAllergiesTextFormFieldValue;
                              modifyPatientInDb(widget.patient);
                            });
                          } else {
                            setState(() {
                              _allergiesController.text =
                                  widget.patient.allergies;
                            });
                          }
                          FocusScope.of(context).unfocus();
                        },
                        onFieldSubmitted: (String newValue) {
                          setState(() {
                            if (currentAllergiesTextFormFieldValue.isNotEmpty) {
                              widget.patient.allergies =
                                  currentAllergiesTextFormFieldValue;
                              modifyPatientInDb(widget.patient);
                            } else {
                              _allergiesController.text =
                                  widget.patient.allergies;
                            }
                          });
                        },
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0.00, 0.00),
                        child: FlutterFlowDropDown(
                          options: const [
                            'Caretaker 1',
                            'Caretaker 12',
                            'Caretaker 13',
                            'Caretaker 14'
                          ],
                          //todo fix this
                          onChanged: (val) => setState(() =>
                              _model.dropDownValue = val as List<String>?),
                          width: 1480,
                          height: 50,
                          textStyle: FlutterFlowTheme.of(context).bodyMedium,
                          hintText: 'Assigned Caretakers',
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 24,
                          ),
                          fillColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          elevation: 2,
                          borderColor: FlutterFlowTheme.of(context).alternate,
                          borderWidth: 2,
                          borderRadius: 8,
                          margin: const EdgeInsetsDirectional.fromSTEB(
                              16, 4, 16, 4),
                          hidesUnderline: true,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 20, 0, 0),
                            child: Text(
                              'Relatives',
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: widget.relatives.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            key: ValueKey<int>(widget.relatives[i].id),
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 1),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                //goto edit relative
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => RelativeFormScreen(
                                        modifying: true,
                                        relative: widget.relatives[i],
                                        patient: widget.patient)));
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 0,
                                      color: Color(0xFFE0E3E7),
                                      offset: Offset(0, 1),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(0),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8, 8, 8, 8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(12, 0, 0, 0),
                                          child: Text(
                                            widget.relatives[i].name,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Align(
                        alignment: const AlignmentDirectional(-1.00, 0.00),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                          child: FFButtonWidget(
                            onPressed: () async {
                              // context.pushNamed('AddRelative');
                              final int relativesCount =
                                  await getRelativesCountFromFirestore();
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RelativeFormScreen(
                                      relative:
                                          Relative.justID(relativesCount + 1),
                                      modifying: false,
                                      patient: widget.patient),
                                  maintainState: false));
                            },
                            text: 'Add Relative',
                            options: FFButtonOptions(
                              width: 150,
                              height: 48,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 0),
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
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
                    ].divide(const SizedBox(height: 12)),
                  ),
                ),
              ],
            ),
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
        widget.patient.dateOfBirth = updatedDateTime;
        _dateController.text =
            "${updatedDateTime.day.toString().padLeft(2, '0')}/${updatedDateTime.month.toString().padLeft(2, '0')}/${updatedDateTime.year}";

        modifyPatientInDb(widget.patient);
      }
    }
  }
}
