import 'package:flutter/material.dart';
import 'package:todoapp/helper/firestore_helper.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_icon_button.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_theme.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_util.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_widgets.dart';
import 'package:todoapp/models/patient.dart';
import 'package:todoapp/models/relative.dart';
import 'package:todoapp/screens/forms/patient_form_screen.dart';
import 'package:todoapp/widget/custom_app_bar.dart';

class RelativeFormScreen extends StatefulWidget {
  final Relative relative;
  final bool modifying;
  final Patient? patient;

  const RelativeFormScreen(
      {super.key,
      required this.relative,
      required this.modifying,
      this.patient});

  @override
  // ignore: library_private_types_in_public_api
  _RelativeFormScreenState createState() => _RelativeFormScreenState();
}

class _RelativeFormScreenState extends State<RelativeFormScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late TextEditingController _nameController;
  late TextEditingController _userNameController;
  late TextEditingController _passwordController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;

  String currentNameTextFormFieldValue = '';
  String currentUserNameTextFormFieldValue = '';
  String currentPasswordTextFormFieldValue = '';
  String currentEmailTextFormFieldValue = '';
  String currentPhoneNumberTextFormFieldValue = '';

  bool passwordFieldVisibility = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    if (widget.modifying) {
      setState(() {
        _nameController.text = widget.relative.name;
        _userNameController.text = widget.relative.userName;
        _passwordController.text = widget.relative.password;
        _emailController.text = widget.relative.email;
        _phoneNumberController.text = widget.relative.phoneNumber;
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
                            'Add new relative',
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
                        TextFormField(
                          controller: _nameController,
                          autofocus: true,
                          obscureText: false,
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
                          onChanged: (String newValue) {
                            setState(() {
                              currentNameTextFormFieldValue = newValue;
                            });
                          },
                          onTapOutside: (newValue) {
                            saveTextValue(
                                currentNameTextFormFieldValue, _nameController,
                                (value) {
                              widget.relative.name = value;
                            }, () {
                              _nameController.text = widget.relative.name;
                            });
                            FocusScope.of(context).unfocus();
                          },
                          onFieldSubmitted: (String newValue) {
                            saveTextValue(
                                currentNameTextFormFieldValue, _nameController,
                                (value) {
                              widget.relative.name = value;
                            }, () {
                              _nameController.text = widget.relative.name;
                            });
                          },
                        ),
                        TextFormField(
                          controller: _userNameController,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'User Name',
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
                              currentUserNameTextFormFieldValue = newValue;
                            });
                          },
                          onTapOutside: (newValue) {
                            saveTextValue(currentUserNameTextFormFieldValue,
                                _userNameController, (value) {
                              widget.relative.userName = value;
                            }, () {
                              _nameController.text = widget.relative.userName;
                            });
                            FocusScope.of(context).unfocus();
                          },
                          onFieldSubmitted: (String newValue) {
                            saveTextValue(currentUserNameTextFormFieldValue,
                                _userNameController, (value) {
                              widget.relative.userName = value;
                            }, () {
                              _nameController.text = widget.relative.userName;
                            });
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          autofocus: true,
                          obscureText: !passwordFieldVisibility,
                          decoration: InputDecoration(
                            labelText: 'Password',
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
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          onChanged: (String newValue) {
                            setState(() {
                              currentPasswordTextFormFieldValue = newValue;
                            });
                          },
                          onTapOutside: (newValue) {
                            saveTextValue(currentPasswordTextFormFieldValue,
                                _passwordController, (value) {
                              widget.relative.password = value;
                            }, () {
                              _passwordController.text =
                                  widget.relative.password;
                            });
                            FocusScope.of(context).unfocus();
                          },
                          onFieldSubmitted: (String newValue) {
                            saveTextValue(currentPasswordTextFormFieldValue,
                                _passwordController, (value) {
                              widget.relative.password = value;
                            }, () {
                              _passwordController.text =
                                  widget.relative.password;
                            });
                          },
                        ),
                        TextFormField(
                          controller: _emailController,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Email',
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
                              currentEmailTextFormFieldValue = newValue;
                            });
                          },
                          onTapOutside: (newValue) {
                            saveTextValue(currentEmailTextFormFieldValue,
                                _emailController, (value) {
                              widget.relative.email = value;
                            }, () {
                              _emailController.text = widget.relative.email;
                            });
                            FocusScope.of(context).unfocus();
                          },
                          onFieldSubmitted: (String newValue) {
                            saveTextValue(currentEmailTextFormFieldValue,
                                _emailController, (value) {
                              widget.relative.email = value;
                            }, () {
                              _emailController.text = widget.relative.email;
                            });
                          },
                        ),
                        TextFormField(
                          controller: _phoneNumberController,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Phone number',
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
                              currentPhoneNumberTextFormFieldValue = newValue;
                            });
                          },
                          onTapOutside: (newValue) {
                            saveTextValue(currentPhoneNumberTextFormFieldValue,
                                _phoneNumberController, (value) {
                              widget.relative.phoneNumber = value;
                            }, () {
                              _phoneNumberController.text =
                                  widget.relative.phoneNumber;
                            });
                            FocusScope.of(context).unfocus();
                          },
                          onFieldSubmitted: (String newValue) {
                            saveTextValue(currentPhoneNumberTextFormFieldValue,
                                _phoneNumberController, (value) {
                              widget.relative.phoneNumber = value;
                            }, () {
                              _phoneNumberController.text =
                                  widget.relative.phoneNumber;
                            });
                          },
                        ),
                        Theme(
                          data: ThemeData(
                            checkboxTheme: const CheckboxThemeData(
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            unselectedWidgetColor:
                                FlutterFlowTheme.of(context).secondaryText,
                          ),
                          child: CheckboxListTile(
                            value: widget.relative.wantsToBeNotified,
                            onChanged: (newValue) async {
                              setState(() => widget.relative.wantsToBeNotified =
                                  newValue!);
                              if (widget.modifying) {
                                modifyRelativeInDb(widget.relative);
                              }
                            },
                            title: Text(
                              'Notifications',
                              style: FlutterFlowTheme.of(context).titleLarge,
                            ),
                            subtitle: Text(
                              'wants to be notified about patient updates',
                              style: FlutterFlowTheme.of(context).labelMedium,
                            ),
                            tileColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            activeColor: FlutterFlowTheme.of(context).primary,
                            checkColor: FlutterFlowTheme.of(context).info,
                            dense: false,
                            controlAffinity: ListTileControlAffinity.trailing,
                          ),
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
                              widget.patient!.relatives.add(widget.relative);
                              modifyPatientInDb(widget.patient!);
                              addRelativeToDb(widget.relative);
                            } else {
                              removeRelativeFromDb(widget.relative.id);
                              widget.patient!.relatives.remove(widget.relative);
                              modifyPatientInDb(widget.patient!);
                              //redirect
                            }
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PatientFormScreen(
                                    patient: widget.patient!,
                                    relatives: widget.patient!.relatives)));
                          });
                        },
                        text: widget.modifying ? 'DELETE' : 'ADD',
                        icon: const Icon(
                          Icons.add,
                          size: 15,
                        ),
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
        if (widget.modifying) modifyRelativeInDb(widget.relative);
      });
    } else {
      setState(() {
        setControllerText();
      });
    }
  }
}
