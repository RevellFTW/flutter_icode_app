// ignore_for_file: use_build_context_synchronously

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/global/variables.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_theme.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_util.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_widgets.dart';
import 'package:todoapp/screens/caretaker_screen.dart';
import 'package:todoapp/widget/custom_app_bar.dart';
import '../../helper/firebase_helper.dart';
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
  late TextEditingController _passwordController;
  final _dateController = MaskedTextController(mask: '00/00/0000');
  String currentNameTextFormFieldValue = '';
  String currentWorkTypesTextFormFieldValue = '';
  String currentAvailabilityTextFormFieldValue = '';
  String currentEmailTextFormFieldValue = '';
  String currentPasswordTextFormFieldValue = '';
  Map<String, Map<String, String>> careTasks = {};
  late DateTime updatedDateTime;
  bool passwordFieldVisibility = false;

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
    _passwordController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        visibility: true,
        title: 'Back to Curamus Back-Office',
        onBackPressed: () async {
          Navigator.of(context).pop(
              MaterialPageRoute(builder: (context) => const CaretakerScreen()));
        },
        isRelative: false,
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
                                        const AlignmentDirectional(-1.00, 0.00),
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
                                                        isRelative: false,
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
                        onTapOutside: (newValue) async {
                          if (currentEmailTextFormFieldValue.isNotEmpty) {
                            setState(() async {
                              widget.caretaker.email =
                                  currentEmailTextFormFieldValue;
                              if (widget.modifying) {
                                String uid = await getUserUID(
                                    'relative', widget.caretaker.id.toString());

                                final HttpsCallable callable = FirebaseFunctions
                                    .instance
                                    .httpsCallable('updateUserEmail');
                                try {
                                  final HttpsCallableResult result =
                                      await callable.call(<String, dynamic>{
                                    'uid': uid,
                                    'newEmail': currentEmailTextFormFieldValue,
                                  });
                                  if (result.data['success']) {
                                    widget.caretaker.email =
                                        currentEmailTextFormFieldValue;
                                    updateUserEmail(
                                        currentEmailTextFormFieldValue, uid);
                                    modifyCaretakerInDb(widget.caretaker);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Email change failed. Please try again later.')));
                                  }
                                } on FirebaseFunctionsException catch (e) {
                                  print(
                                      'Failed to update email: ${e.code}\n${e.message}');
                                }
                              }
                            });
                          } else {
                            setState(() {
                              _emailController.text = widget.caretaker.email;
                            });
                          }
                          FocusScope.of(context).unfocus();
                        },
                        onFieldSubmitted: (String newValue) async {
                          setState(() async {
                            if (currentEmailTextFormFieldValue.isNotEmpty) {
                              widget.caretaker.email =
                                  currentEmailTextFormFieldValue;
                              if (widget.modifying) {
                                String uid = await getUserUID(
                                    'relative', widget.caretaker.id.toString());

                                final HttpsCallable callable = FirebaseFunctions
                                    .instance
                                    .httpsCallable('updateUserEmail');
                                try {
                                  final HttpsCallableResult result =
                                      await callable.call(<String, dynamic>{
                                    'uid': uid,
                                    'newEmail': currentEmailTextFormFieldValue,
                                  });
                                  if (result.data['success']) {
                                    widget.caretaker.email =
                                        currentEmailTextFormFieldValue;
                                    updateUserEmail(
                                        currentEmailTextFormFieldValue, uid);
                                    modifyCaretakerInDb(widget.caretaker);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Email change failed. Please try again later.')));
                                  }
                                } on FirebaseFunctionsException catch (e) {
                                  print(
                                      'Failed to update email: ${e.code}\n${e.message}');
                                }
                              }
                            } else {
                              _emailController.text = widget.caretaker.email;
                            }
                          });
                        },
                      ),
                      !widget.modifying
                          ? TextFormField(
                              controller: _passwordController,
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
                              onTapOutside: (newValue) async {
                                FocusScope.of(context).unfocus();
                              },
                              onFieldSubmitted: (String newValue) async {
                                setState(() {
                                  currentPasswordTextFormFieldValue = newValue;
                                });
                              },
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            )
                          : Container(),
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
                      widget.modifying
                          ? Align(
                              alignment: const AlignmentDirectional(0.00, 0.00),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 34, 0, 0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Change Password'),
                                          content: const Text(
                                              'Please enter your new password.'),
                                          actions: <Widget>[
                                            TextFormField(
                                              autofocus: true,
                                              obscureText: false,
                                              decoration: InputDecoration(
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
                                                  currentPasswordTextFormFieldValue =
                                                      value;
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
                                                    String uid =
                                                        await getUserUID(
                                                            'caretaker',
                                                            widget.caretaker.id
                                                                .toString());

                                                    final HttpsCallable
                                                        callable =
                                                        FirebaseFunctions
                                                            .instance
                                                            .httpsCallable(
                                                                'updateUserPassword');
                                                    try {
                                                      final HttpsCallableResult
                                                          result =
                                                          await callable
                                                              .call(<String,
                                                                  dynamic>{
                                                        'uid': uid,
                                                        'newPassword':
                                                            currentPasswordTextFormFieldValue,
                                                      });
                                                      if (result
                                                          .data['success']) {
                                                        print(
                                                            'Password updated successfully');
                                                      } else {
                                                        print(
                                                            'Password update failed');
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        'Password change failed. Please try again later.')));
                                                      }
                                                    } on FirebaseFunctionsException catch (e) {
                                                      print(
                                                          'Failed to update Password: ${e.code}\n${e.message}');
                                                    }
                                                  },
                                                  text: 'CONFIRM',
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
                                  text: 'CHANGE PASSWORD',
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
                      Align(
                        alignment: const AlignmentDirectional(0.00, 0.00),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0, 34, 0, 12),
                          child: FFButtonWidget(
                            onPressed: () async {
                              if (!widget.modifying) {
                                setState(() {
                                  if (widget.caretaker.name.isEmpty ||
                                      widget.caretaker.email.isEmpty ||
                                      widget.caretaker.workTypes.isEmpty ||
                                      widget.caretaker.availability.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please fill all the fields',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                });

                                UserCredential result = await register(
                                    widget.caretaker.email,
                                    currentPasswordTextFormFieldValue);
                                setState(() {
                                  User user = result.user!;
                                  addCaretakerUserInDb(
                                      widget.caretaker, user.uid);
                                  addCaretakerToDb(widget.caretaker);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const CaretakerScreen()));
                                });
                              } else {
                                removeCaretakerFromDb(widget.caretaker.id);
                              }
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const CaretakerScreen()));
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
