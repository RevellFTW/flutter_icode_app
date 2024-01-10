import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/global/variables.dart';
import 'package:todoapp/helper/firestore_helper.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_theme.dart';
import 'package:todoapp/models/patient.dart';
import 'package:todoapp/models/relative.dart';
import 'package:todoapp/screens/forms/caretask_form_screen.dart';
import 'package:todoapp/screens/forms/patient_form_screen.dart';
import 'package:todoapp/screens/home_page.dart';
import 'package:todoapp/widget/custom_app_bar.dart';

class CareTasksPage extends StatefulWidget {
  final Patient patient;
  final bool visibility;
  const CareTasksPage(
      {super.key, required this.patient, required this.visibility});

  @override
  // ignore: library_private_types_in_public_api
  _CareTasksPageState createState() => _CareTasksPageState();
}

class _CareTasksPageState extends State<CareTasksPage> {
  final TextEditingController _patientNameController = TextEditingController();
  List<Patient> patients = [];
  final TextEditingController _searchController = TextEditingController();
  List<Patient> _filteredPatients = [];

  Patient? getPatient(int id) {
    return patients.firstWhere((patient) => patient.id == id);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        visibility: widget.visibility,
        title: 'Back to ${widget.patient.name}\'s sheet',
        onBackPressed: () {
          Navigator.of(context).pop(MaterialPageRoute(
              builder: (context) => PatientFormScreen(
                    patient: widget.patient,
                    caretakerList: caretakerList,
                    visibility: widget.visibility,
                  )));
        },
        //todo handle different callers here
        caller: Caller.backOfficePatient,
      ),
      body: Column(
        children: [
          Align(
            alignment: const AlignmentDirectional(-1.00, 0.00),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 15, 0, 0),
              child: Text(
                '${widget.patient.name}\'s care tasks',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily: 'Outfit',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
              child: ListView.builder(
                  itemCount: widget.patient.careTasks.length,
                  itemBuilder: (context, i) {
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: <Widget>[
                          SlidableAction(
                            onPressed: (context) => {
                              setState(() {
                                widget.patient.careTasks.removeAt(i);
                              }),
                              saveToDb()
                            },
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                          ),
                        ],
                      ),
                      key: ValueKey<int>(i),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
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
                              ),
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
                                Container(
                                  width: 4,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 0, 0),
                                    child: Text(
                                      widget.patient.careTasks[i].taskName,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      12, 0, 15, 0),
                                  child: Text(
                                    widget.patient.careTasks[i].date,
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium,
                                  ),
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => CareTasksForm(
                                                  patient: widget.patient,
                                                  modifying: true,
                                                  caretaskIndex: i,
                                                  isClickedDirectly: true,
                                                  visibility: widget.visibility,
                                                )));
                                  },
                                  child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              4, 4, 4, 4),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CareTasksForm(
                                                        patient: widget.patient,
                                                        modifying: true,
                                                        caretaskIndex: i,
                                                        isClickedDirectly: true,
                                                        visibility:
                                                            widget.visibility,
                                                      )));
                                        },
                                        child: Icon(
                                          Icons.keyboard_arrow_right_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        backgroundColor: appBackgroundColor,
        foregroundColor: appForegroundColor,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CareTasksForm(
                    patient: widget.patient,
                    modifying: false,
                    caretaskIndex: -1,
                    isClickedDirectly: false,
                    visibility: widget.visibility,
                  )));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  saveToDb() {
    getDocumentID(widget.patient.id, 'patients').then((docID) {
      updatePatient(widget.patient, docID);
    });
  }
}
