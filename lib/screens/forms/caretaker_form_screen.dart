// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_theme.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_util.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_widgets.dart';
import 'package:todoapp/screens/caretaker_screen.dart';
import 'package:todoapp/widget/custom_app_bar.dart';
import '../../helper/firestore_helper.dart';
import '../../models/caretaker.dart';
import '../../models/event_log.dart';
import '../home_page.dart';
import '../tasks_and_logs/event_log_screen.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class CaretakerFormScreen extends StatefulWidget {
  final Caretaker caretaker;
  final bool modifying;
  const CaretakerFormScreen(
      {super.key, required this.caretaker, this.modifying = true});

  @override
  // ignore: library_private_types_in_public_api
  _CaretakerFormScreenState createState() => _CaretakerFormScreenState();
}

class _CaretakerFormScreenState extends State<CaretakerFormScreen> {
  late TextEditingController _nameController;
  late TextEditingController _workTypesController;
  late TextEditingController _availabilityController;
  late TextEditingController _emailController;
  final _dateController = MaskedTextController(mask: '00/00/0000');
  String currentNameTextFormFieldValue = '';
  String currentWorkTypesTextFormFieldValue = '';
  String currentAvailabilityTextFormFieldValue = '';
  String currentEmailTextFormFieldValue = '';
  Map<String, Map<String, String>> careTasks = {};
  late DateTime updatedDateTime;

  @override
  void initState() {
    super.initState();
    updatedDateTime = widget.caretaker.dateOfBirth;
    _nameController = TextEditingController(text: widget.caretaker.name);
    _dateController.text =
        "${widget.caretaker.dateOfBirth.day.toString().padLeft(2, '0')}/${widget.caretaker.dateOfBirth.month.toString().padLeft(2, '0')}/${widget.caretaker.dateOfBirth.year}";
    _workTypesController =
        TextEditingController(text: widget.caretaker.workTypes);
    _availabilityController =
        TextEditingController(text: widget.caretaker.availability);
    _emailController = TextEditingController(text: widget.caretaker.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Back to Curamus Back-Office',
        onBackPressed: () async {
          Navigator.of(context).pop(
              MaterialPageRoute(builder: (context) => const CaretakerScreen()));
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
                      widget.modifying
                          ? '${widget.caretaker.name}\'s sheet'
                          : 'Add new caretaker',
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
                                Flexible(
                                  child: Align(
                                    alignment:
                                        const AlignmentDirectional(1.00, 0.00),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 12),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          List<EventLog> tasks =
                                              await loadEventLogsFromFirestore(
                                                  widget.caretaker.id,
                                                  Caller.caretaker);
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EventLogScreen(
                                                        eventLogs: tasks,
                                                        eventLogName:
                                                            "${widget.caretaker.name} Caretaker's Log",
                                                        caller:
                                                            Caller.caretaker,
                                                        caretaker:
                                                            widget.caretaker,
                                                      )));
                                        },
                                        text: 'Event Logs',
                                        options: FFButtonOptions(
                                          width: 150,
                                          height: 48,
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 0, 0),
                                          iconPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 0, 0),
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily: 'Readex Pro',
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
                                ),
                              ],
                            )
                          : Container(),
                      TextFormField(
                        controller: _nameController,
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
                              widget.caretaker.name =
                                  currentNameTextFormFieldValue;
                              if (widget.modifying)
                                modifyCaretakerInDb(widget.caretaker);
                            });
                          } else {
                            setState(() {
                              _nameController.text = widget.caretaker.name;
                            });
                          }
                          FocusScope.of(context).unfocus();
                        },
                        onFieldSubmitted: (String newValue) {
                          setState(() {
                            if (currentNameTextFormFieldValue.isNotEmpty) {
                              widget.caretaker.name =
                                  currentNameTextFormFieldValue;
                              if (widget.modifying)
                                modifyCaretakerInDb(widget.caretaker);
                            } else {
                              _nameController.text = widget.caretaker.name;
                            }
                          });
                        },
                        style: FlutterFlowTheme.of(context).bodyMedium,
                      ),
                      TextFormField(
                        onTap: () =>
                            updateStartDate(widget.caretaker.dateOfBirth),
                        //enabled: false,
                        keyboardType: TextInputType.datetime,
                        controller: _dateController,
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
                        controller: _emailController,
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
                        style: FlutterFlowTheme.of(context).bodyMedium,
                        onChanged: (String newValue) {
                          setState(() {
                            currentEmailTextFormFieldValue = newValue;
                          });
                        },
                        onTapOutside: (newValue) {
                          if (currentEmailTextFormFieldValue.isNotEmpty) {
                            setState(() {
                              widget.caretaker.email =
                                  currentEmailTextFormFieldValue;
                              if (widget.modifying)
                                modifyCaretakerInDb(widget.caretaker);
                            });
                          } else {
                            setState(() {
                              _emailController.text = widget.caretaker.email;
                            });
                          }
                          FocusScope.of(context).unfocus();
                        },
                        onFieldSubmitted: (String newValue) {
                          setState(() {
                            if (currentEmailTextFormFieldValue.isNotEmpty) {
                              widget.caretaker.email =
                                  currentEmailTextFormFieldValue;
                              if (widget.modifying)
                                modifyCaretakerInDb(widget.caretaker);
                            } else {
                              _emailController.text = widget.caretaker.email;
                            }
                          });
                        },
                      ),
                      TextFormField(
                        controller: _workTypesController,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Work types taken',
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
                            currentWorkTypesTextFormFieldValue = newValue;
                          });
                        },
                        onTapOutside: (newValue) {
                          if (currentWorkTypesTextFormFieldValue.isNotEmpty) {
                            setState(() {
                              widget.caretaker.workTypes =
                                  currentWorkTypesTextFormFieldValue;
                              if (widget.modifying)
                                modifyCaretakerInDb(widget.caretaker);
                            });
                          } else {
                            setState(() {
                              _workTypesController.text =
                                  widget.caretaker.workTypes;
                            });
                          }
                          FocusScope.of(context).unfocus();
                        },
                        onFieldSubmitted: (String newValue) {
                          setState(() {
                            if (currentWorkTypesTextFormFieldValue.isNotEmpty) {
                              widget.caretaker.workTypes =
                                  currentWorkTypesTextFormFieldValue;
                              if (widget.modifying)
                                modifyCaretakerInDb(widget.caretaker);
                            } else {
                              _workTypesController.text =
                                  widget.caretaker.workTypes;
                            }
                          });
                        },
                        // validator: _model.textFieldController3Validator
                        //     .asValidator(context),
                      ),
                      TextFormField(
                        controller: _availabilityController,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Availability',
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
                            currentAvailabilityTextFormFieldValue = newValue;
                          });
                        },
                        onTapOutside: (newValue) {
                          if (currentAvailabilityTextFormFieldValue
                              .isNotEmpty) {
                            setState(() {
                              widget.caretaker.availability =
                                  currentAvailabilityTextFormFieldValue;
                              if (widget.modifying)
                                modifyCaretakerInDb(widget.caretaker);
                            });
                          } else {
                            setState(() {
                              _availabilityController.text =
                                  widget.caretaker.availability;
                            });
                          }
                          FocusScope.of(context).unfocus();
                        },
                        onFieldSubmitted: (String newValue) {
                          setState(() {
                            if (currentAvailabilityTextFormFieldValue
                                .isNotEmpty) {
                              widget.caretaker.availability =
                                  currentAvailabilityTextFormFieldValue;
                              if (widget.modifying)
                                modifyCaretakerInDb(widget.caretaker);
                            } else {
                              _availabilityController.text =
                                  widget.caretaker.availability;
                            }
                          });
                        },
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0.00, 0.00),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0, 34, 0, 12),
                          child: FFButtonWidget(
                            onPressed: () {
                              setState(() {
                                if (!widget.modifying) {
                                  addCaretakerToDb(widget.caretaker);
                                } else {
                                  removeCaretakerFromDb(widget.caretaker.id);
                                }
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const CaretakerScreen()));
                              });
                            },
                            text: widget.modifying ? 'DELETE' : 'ADD',
                            options: FFButtonOptions(
                              width: 600,
                              height: 48,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
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
        widget.caretaker.dateOfBirth = updatedDateTime;
        _dateController.text =
            "${updatedDateTime.day.toString().padLeft(2, '0')}/${updatedDateTime.month.toString().padLeft(2, '0')}/${updatedDateTime.year}";

        if (widget.modifying) modifyCaretakerInDb(widget.caretaker);
      }
    }
  }
}
