import 'package:todoapp/global/variables.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/models/caretaker.dart';
import 'package:todoapp/models/patient.dart';
import 'package:todoapp/screens/forms/patient_form_screen.dart';
import 'package:todoapp/screens/home_page.dart';
import '../helper/flutter_flow/flutter_flow_icon_button.dart';
import '../helper/flutter_flow/flutter_flow_theme.dart';
import '../helper/flutter_flow/flutter_flow_util.dart';
import '../helper/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen(
      this.caller, this.backToText, this.patient, this.caretakers,
      {Key? key})
      : super(key: key);
  static const String id = 'settings_screen';
  final Caller caller;
  final String backToText;
  final Patient? patient;
  final List<Caretaker>? caretakers;

  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late String appName;
  @override
  void initState() {
    super.initState();
    switch (widget.caller) {
      case Caller.backOfficePatient:
        appName = 'Back Office Application';
        break;
      case Caller.backOfficeCaretaker:
        appName = 'Back Office Application';
        break;
      case Caller.patient:
        appName = 'Patient Application';
        break;
      case Caller.caretaker:
        appName = 'Caretaker Application';
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: appBackgroundColor,
          foregroundColor: appForegroundColor,
          automaticallyImplyLeading: false,
          actions: const [],
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
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                12, 0, 0, 0),
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
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                4, 0, 0, 0),
                            child: Text(
                              "Back to ${widget.backToText}",
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
                  ),
                ],
              ),
            ),
            centerTitle: true,
            expandedTitleScale: 1.0,
          ),
          elevation: 2,
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 8),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align texts to the start
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                  child: Text(
                    'Logged In user:',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Outfit',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 10, 0),
                  child: Text(
                    //todo add user name
                    auth.currentUser!.email.toString(),
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Outfit',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(23, 30, 0, 0),
            child: Text(
              appName,
              style: FlutterFlowTheme.of(context).titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(23, 4, 0, 0),
            child: Text(
              'v0.0.1',
              style: FlutterFlowTheme.of(context).labelMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 0, 0),
            child: FFButtonWidget(
              onPressed: () async {
                auth.signOut();
                //remove homepage route

                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const MyApp(),
                    ),
                    (route) => false);
              },
              text: 'Log Out',
              options: FFButtonOptions(
                height: 40,
                padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                color: FlutterFlowTheme.of(context).secondaryBackground,
                textStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'Readex Pro',
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                elevation: 0,
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          Expanded(child: showSettings(context)),
        ],
      ),
    );
  }

  Widget showSettings(BuildContext context) {
    if (widget.caller == Caller.patient) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 30, 0, 0),
            child: Text(
              'Settings ',
              style: FlutterFlowTheme.of(context).headlineSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 0, 0),
            child: Text(
              'Please evaluate your options below.',
              style: FlutterFlowTheme.of(context).labelMedium,
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
                  child: InkWell(
                    onTap: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PatientFormScreen(
                            patient: widget.patient!,
                            caretakerList: caretakerList,
                            visibility: false,
                            modifying: false,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'View patient data',
                              style: FlutterFlowTheme.of(context).titleLarge,
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ].addToEnd(const SizedBox(height: 64)),
      );
    } else {
      return Container();
    }
  }
}
