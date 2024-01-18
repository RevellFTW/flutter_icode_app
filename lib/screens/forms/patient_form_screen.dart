import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_count_controller.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_drop_down.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_theme.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_util.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_widgets.dart';
import 'package:todoapp/models/caretaker.dart';
import 'package:todoapp/models/relative.dart';
import 'package:todoapp/screens/patient_screen.dart';
import 'package:todoapp/widget/custom_app_bar.dart';
import '../../global/variables.dart';
import '../../helper/firestore_helper.dart';
import '../../models/patient.dart';
import '../../models/event_log.dart';
import '../home_page.dart';
import '../tasks_and_logs/caretask_screen.dart';
import '../tasks_and_logs/event_log_screen.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import '../../models/patient_form_model.dart';
import 'relative_form_screen.dart';
export '../../models/patient_form_model.dart';

class PatientFormScreen extends StatefulWidget {
  final Patient patient;
  final List<Caretaker> caretakerList;
  final bool visibility;
  final bool isRelative;
  final bool modifying;
  const PatientFormScreen(
      {super.key,
      required this.patient,
      required this.caretakerList,
      required this.visibility,
      required this.isRelative,
      this.modifying = true});
  static const id = 'patient_form_screen';

  @override
  // ignore: library_private_types_in_public_api
  _PatientFormScreenState createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordController1;
  late TextEditingController _passwordController2;
  late TextEditingController _medicalStateController;
  late TextEditingController _takenMedicinesController;
  late TextEditingController _allergiesController;
  final _dateController = MaskedTextController(mask: '00/00/0000');
  String currentNameTextFormFieldValue = '';
  String currentEmailTextFormFieldValue = '';
  String currentPasswordTextFormFieldValue = '';
  String currentMedicalStateTextFormFieldValue = '';
  String currentTakenMedicinesTextFormFieldValue = '';
  String currentAllergiesTextFormFieldValue = '';
  Map<String, Map<String, String>> careTasks = {};
  late DateTime updatedDateTime;
  late PatientFormModel _model;
  bool passwordFieldVisibility = false;

  List<ValueItem<String>> selectedCaretakerValueItems = [];

  List<Relative> relatives = [];

  MultiSelectController<String> multiSelectDropdownController =
      MultiSelectController<String>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PatientFormModel());
    if (widget.modifying) {
      relatives = widget.patient.relatives;
      selectedCaretakerValueItems =
          caretakerListToValueItemList(widget.patient.assignedCaretakers!);

      updatedDateTime = widget.patient.startDate;
      _nameController = TextEditingController(text: widget.patient.name);
      _emailController = TextEditingController(text: widget.patient.email);
      _passwordController = TextEditingController(text: widget.patient.email);
      _passwordController1 = TextEditingController(text: '');
      _passwordController2 = TextEditingController(text: '');
      _dateController.text =
          "${widget.patient.dateOfBirth.day.toString().padLeft(2, '0')}/${widget.patient.dateOfBirth.month.toString().padLeft(2, '0')}/${widget.patient.dateOfBirth.year}";
      _medicalStateController =
          TextEditingController(text: widget.patient.medicalState);
      _takenMedicinesController =
          TextEditingController(text: widget.patient.takenMedicines);
      _allergiesController =
          TextEditingController(text: widget.patient.allergies);

      multiSelectDropdownController
          .setOptions(caretakerListToValueItemList(widget.caretakerList));

      multiSelectDropdownController
          .setSelectedOptions(selectedCaretakerValueItems);
    } else {
      _nameController = TextEditingController(text: '');
      _emailController = TextEditingController(text: '');
      _passwordController = TextEditingController(text: '');
      _passwordController1 = TextEditingController(text: '');
      _passwordController2 = TextEditingController(text: '');
      _dateController.text = '';
      _medicalStateController = TextEditingController(text: '');
      _takenMedicinesController = TextEditingController(text: '');
      _allergiesController = TextEditingController(text: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Back to Curamus Back-Office',
        visibility: widget.visibility,
        onBackPressed: () async {
          Navigator.of(context).pop();
        },
        isRelative: widget.isRelative,
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
                      widget.modifying
                          ? '${widget.patient.name}\'s sheet'
                          : 'Add new patient',
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
                      widget.modifying
                          ? Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Align(
                                  alignment:
                                      const AlignmentDirectional(-1.00, 0.00),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 12),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CareTasksPage(
                                                      patient: widget.patient,
                                                      visibility: widget
                                                              .isRelative
                                                          ? true
                                                          : widget.visibility,
                                                      isRelative:
                                                          widget.isRelative,
                                                    )));
                                      },
                                      text: 'Care Tasks',
                                      options: FFButtonOptions(
                                        width: 150,
                                        height: 48,
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 0),
                                        iconPadding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 0),
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
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
                                widget.visibility
                                    ? Flexible(
                                        child: Align(
                                          alignment: const AlignmentDirectional(
                                              1.00, 0.00),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 0, 12),
                                            child: FFButtonWidget(
                                              onPressed: () async {
                                                List<EventLog> eventLogs = [];

                                                loadEventLogsFromFirestore(
                                                        widget.patient.id,
                                                        Caller.patient)
                                                    .then((value) {
                                                  setState(() {
                                                    eventLogs = value;
                                                  });
                                                });

                                                // ignore: use_build_context_synchronously

                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EventLogScreen(
                                                              eventLogs:
                                                                  eventLogs,
                                                              eventLogName:
                                                                  "${widget.patient.name} Patient's Log",
                                                              caller: Caller
                                                                  .backOfficePatient,
                                                              patient: widget
                                                                  .patient,
                                                              isRelative: widget
                                                                  .isRelative,
                                                            )));
                                              },
                                              text: 'Event Logs',
                                              options: FFButtonOptions(
                                                width: 150,
                                                height: 48,
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 0, 0, 0),
                                                iconPadding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 0, 0, 0),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                elevation: 4,
                                                borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(60),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            )
                          : Container(),
                      TextFormField(
                        controller: _nameController,
                        focusNode: _model.textFieldFocusNode1,
                        autofocus: true,
                        obscureText: false,
                        readOnly: !widget.visibility,
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
                              if (widget.modifying)
                                modifyPatientInDb(widget.patient);
                            });
                          } else {
                            setState(() {
                              _nameController.text = widget.patient.name;
                            });
                          }
                          _model.textFieldFocusNode1!.unfocus();
                        },
                        onFieldSubmitted: (String newValue) {
                          setState(() {
                            if (currentNameTextFormFieldValue.isNotEmpty) {
                              widget.patient.name =
                                  currentNameTextFormFieldValue;
                              if (widget.modifying)
                                modifyPatientInDb(widget.patient);
                            } else {
                              _nameController.text = widget.patient.name;
                            }
                          });
                        },
                        style: FlutterFlowTheme.of(context).bodyMedium,
                      ),
                      TextFormField(
                        controller: _emailController,
                        focusNode: _model.textFieldFocusNode6,
                        readOnly: !widget.visibility,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Email',
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
                            currentEmailTextFormFieldValue = newValue;
                          });
                        },
                        onTapOutside: (newValue) {
                          if (currentEmailTextFormFieldValue.isNotEmpty) {
                            setState(() {
                              widget.patient.email =
                                  currentEmailTextFormFieldValue;
                              if (widget.modifying)
                                modifyPatientInDb(widget.patient);
                            });
                          } else {
                            setState(() {
                              _emailController.text = widget.patient.email;
                            });
                          }
                          _model.textFieldFocusNode6!.unfocus();
                        },
                        onFieldSubmitted: (String newValue) {
                          setState(() {
                            if (currentEmailTextFormFieldValue.isNotEmpty) {
                              widget.patient.email =
                                  currentEmailTextFormFieldValue;
                              if (widget.modifying)
                                modifyPatientInDb(widget.patient);
                            } else {
                              _emailController.text = widget.patient.email;
                            }
                          });
                        },
                        style: FlutterFlowTheme.of(context).bodyMedium,
                      ),
                      !widget.modifying
                          ? TextFormField(
                              controller: _passwordController,
                              focusNode: _model.textFieldFocusNode7,
                              readOnly: !widget.visibility,
                              obscureText: !passwordFieldVisibility,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                hintStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
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
                                suffixIcon: InkWell(
                                  onTap: () => setState(
                                    () => passwordFieldVisibility =
                                        !passwordFieldVisibility,
                                  ),
                                  focusNode: FocusNode(skipTraversal: true),
                                  child: Icon(
                                    passwordFieldVisibility
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 20,
                                  ),
                                ),
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  currentPasswordTextFormFieldValue = newValue;
                                });
                              },
                              onTapOutside: (newValue) {
                                _model.textFieldFocusNode6!.unfocus();
                              },
                              onFieldSubmitted: (String newValue) {
                                setState(() {
                                  currentPasswordTextFormFieldValue = newValue;
                                });
                              },
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            )
                          : Container(),
                      TextFormField(
                        onTap: widget.visibility
                            ? () => updateStartDate(widget.patient.dateOfBirth)
                            : null,
                        keyboardType: TextInputType.datetime,
                        readOnly: !widget.visibility,
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
                        readOnly: !widget.visibility,
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
                              if (widget.modifying)
                                modifyPatientInDb(widget.patient);
                            });
                          } else {
                            setState(() {
                              _medicalStateController.text =
                                  widget.patient.medicalState;
                            });
                          }
                          _model.textFieldFocusNode3!.unfocus();
                        },
                        onFieldSubmitted: (String newValue) {
                          setState(() {
                            if (currentMedicalStateTextFormFieldValue
                                .isNotEmpty) {
                              widget.patient.medicalState =
                                  currentMedicalStateTextFormFieldValue;
                              if (widget.modifying)
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
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 2,
                                    ),
                                  ),
                                  child: widget.visibility
                                      ? FlutterFlowCountController(
                                          decrementIconBuilder: (enabled) =>
                                              FaIcon(
                                            FontAwesomeIcons.minus,
                                            color: enabled
                                                ? FlutterFlowTheme.of(context)
                                                    .secondaryText
                                                : FlutterFlowTheme.of(context)
                                                    .alternate,
                                            size: 20,
                                          ),
                                          incrementIconBuilder: (enabled) =>
                                              FaIcon(
                                            FontAwesomeIcons.plus,
                                            color: enabled
                                                ? FlutterFlowTheme.of(context)
                                                    .primary
                                                : FlutterFlowTheme.of(context)
                                                    .alternate,
                                            size: 20,
                                          ),
                                          countBuilder: (count) => Text(
                                            count.toString(),
                                            style: FlutterFlowTheme.of(context)
                                                .titleLarge,
                                          ),
                                          count: widget.patient.dailyHours ??=
                                              0,
                                          updateCount: (count) => {
                                            setState(() => widget
                                                .patient.dailyHours = count),
                                            if (widget.modifying)
                                              modifyPatientInDb(widget.patient)
                                          },
                                          stepSize: 1,
                                          minimum: 1,
                                          maximum: 12,
                                        )
                                      : Text(
                                          widget.patient.dailyHours.toString(),
                                          style: FlutterFlowTheme.of(context)
                                              .titleLarge
                                              .override(
                                                fontFamily: 'Poppins',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 24,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        )),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: _takenMedicinesController,
                        focusNode: _model.textFieldFocusNode4,
                        readOnly: !widget.visibility,
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
                              if (widget.modifying)
                                modifyPatientInDb(widget.patient);
                            });
                          } else {
                            setState(() {
                              _takenMedicinesController.text =
                                  widget.patient.takenMedicines;
                            });
                          }
                          _model.textFieldFocusNode4!.unfocus();
                        },
                        onFieldSubmitted: (String newValue) {
                          setState(() {
                            if (currentTakenMedicinesTextFormFieldValue
                                .isNotEmpty) {
                              widget.patient.takenMedicines =
                                  currentTakenMedicinesTextFormFieldValue;
                              if (widget.modifying)
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
                        readOnly: !widget.visibility,
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
                              if (widget.modifying)
                                modifyPatientInDb(widget.patient);
                            });
                          } else {
                            setState(() {
                              _allergiesController.text =
                                  widget.patient.allergies;
                            });
                          }
                          _model.textFieldFocusNode5!.unfocus();
                        },
                        onFieldSubmitted: (String newValue) {
                          setState(() {
                            if (currentAllergiesTextFormFieldValue.isNotEmpty) {
                              widget.patient.allergies =
                                  currentAllergiesTextFormFieldValue;
                              if (widget.modifying)
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
                        child: IgnorePointer(
                          ignoring: !widget.visibility,
                          child: MultiSelectDropDown<String>(
                            controller: multiSelectDropdownController,
                            onOptionSelected: widget.visibility
                                ? (List<ValueItem> selectedOptions) {
                                    var selectedItems = selectedOptions
                                        .map((option) => option.value)
                                        .toList();
                                    widget.patient.assignedCaretakers = widget
                                        .caretakerList
                                        .where((element) => selectedItems
                                            .contains(element.id.toString()))
                                        .toList();
                                    if (widget.modifying)
                                      modifyPatientInDb(widget.patient);
                                  }
                                : null,
                            options: caretakerListToValueItemList(
                                widget.caretakerList),
                            selectionType: SelectionType.multi,
                            chipConfig: ChipConfig(
                                wrapType: WrapType.wrap,
                                backgroundColor:
                                    FlutterFlowTheme.of(context).primary),
                            dropdownHeight: 140,
                            optionTextStyle:
                                FlutterFlowTheme.of(context).bodyMedium,
                            selectedOptionIcon: Icon(
                              Icons.check_circle,
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                            borderColor: FlutterFlowTheme.of(context).alternate,
                            borderWidth: 2,
                            borderRadius: 8,
                          ),
                        ),
                      ),
                      widget.modifying
                          ? Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              10, 20, 0, 0),
                                      child: Text(
                                        'Relatives',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                                ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: relatives.length,
                                  itemBuilder: (context, i) {
                                    return Padding(
                                      key: ValueKey<int>(relatives[i].id),
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 1),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          //goto edit relative
                                          //if not a relative and not a patient => edit relative
                                          if (!widget.isRelative &&
                                              widget.visibility) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RelativeFormScreen(
                                                          modifying: true,
                                                          relative:
                                                              relatives[i],
                                                          patient:
                                                              widget.patient,
                                                          visibility:
                                                              widget.visibility,
                                                        )));
                                          }
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
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(8, 8, 8, 8),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            12, 0, 0, 0),
                                                    child: Text(
                                                      relatives[i].name,
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
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
                                widget.visibility
                                    ? Align(
                                        alignment: const AlignmentDirectional(
                                            -1.00, 0.00),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 10, 0, 12),
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              // context.pushNamed('AddRelative');
                                              final int relativesCount =
                                                  await getRelativesCountFromFirestore();
                                              // ignore: use_build_context_synchronously
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          RelativeFormScreen(
                                                              relative: Relative
                                                                  .justID(
                                                                      relativesCount +
                                                                          1),
                                                              modifying: false,
                                                              visibility: widget
                                                                  .visibility,
                                                              patient: widget
                                                                  .patient),
                                                      maintainState: false));
                                            },
                                            text: 'Add Relative',
                                            options: FFButtonOptions(
                                              width: 150,
                                              height: 48,
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                              iconPadding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                              elevation: 4,
                                              borderSide: const BorderSide(
                                                color: Colors.transparent,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            )
                          : Container(),
                      (widget.visibility && widget.modifying)
                          ? Align(
                              alignment: const AlignmentDirectional(0.00, 0.00),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 34, 0, 0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    String email = '';
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Reset Password'),
                                          content: const Text(
                                              'Please enter your email address to reset your password.'),
                                          actions: <Widget>[
                                            TextFormField(
                                              autofocus: true,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                labelText: 'Email',
                                                labelStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium,
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium,
                                              onChanged: (value) {
                                                setState(() {
                                                  email = value;
                                                });
                                              },
                                            ),
                                            Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0.00, 0.00),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 34, 0, 12),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    if (email ==
                                                        widget.patient.email) {
                                                      await auth
                                                          .sendPasswordResetEmail(
                                                              email: email);
                                                      Navigator.of(context)
                                                          .pop();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                        content: Text(
                                                            'Password reset email sent successfully.'),
                                                        duration: Duration(
                                                            seconds: 3),
                                                      ));
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                        content: Text(
                                                            'Email does not match.'),
                                                        duration: Duration(
                                                            seconds: 3),
                                                      ));
                                                    }
                                                  },
                                                  text: 'SEND',
                                                  options: FFButtonOptions(
                                                    width: 150,
                                                    height: 48,
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 0, 0, 0),
                                                    iconPadding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 0, 0, 0),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          color: Colors.white,
                                                        ),
                                                    elevation: 4,
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  text: 'RESET PASSWORD',
                                  options: FFButtonOptions(
                                    width: 600,
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
                            )
                          : Container(),
                      widget.visibility
                          ? Align(
                              alignment: const AlignmentDirectional(0.00, 0.00),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 20, 0, 12),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    if (!widget.modifying) {
                                      setState(() {
                                        if (widget.patient.name.isEmpty ||
                                            widget.patient.email.isEmpty ||
                                            widget
                                                .patient.medicalState.isEmpty ||
                                            widget.patient.assignedCaretakers!
                                                .isEmpty ||
                                            widget.patient.dailyHours < 1) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Please fill name, medical state, daily hours and assign at least one caretaker",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          );
                                          return;
                                        }
                                      });
                                      UserCredential result = await register(
                                          widget.patient.email,
                                          currentPasswordTextFormFieldValue);
                                      setState(() {
                                        User user = result.user!;
                                        addPatientUserInDb(
                                            widget.patient, user.uid);
                                        addPatientToDb(widget.patient);
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const PatientScreen()));
                                      });
                                    } else {
                                      print(
                                          'todo remove patient from auth users');
                                      removePatientFromDb(widget.patient.id);
                                    }
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PatientScreen()));
                                  },
                                  text: widget.modifying ? 'DELETE' : 'ADD',
                                  options: FFButtonOptions(
                                    width: 600,
                                    height: 48,
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                    iconPadding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                    color: widget.modifying
                                        ? const Color(0xFFEFEFEF)
                                        : FlutterFlowTheme.of(context).primary,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
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
                            )
                          : Container(),
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

  List<ValueItem<String>> caretakerListToValueItemList(
      List<Caretaker> caretakers) {
    List<ValueItem<String>> caretakerValueItemList = [];
    caretakers.forEach((caretaker) {
      caretakerValueItemList.add(
          ValueItem(label: caretaker.name, value: caretaker.id.toString()));
    });
    return caretakerValueItemList;
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

        if (widget.modifying) modifyPatientInDb(widget.patient);
      }
    }
  }
}
