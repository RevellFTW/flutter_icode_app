import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import '../../helper/flutter_flow/flutter_flow_icon_button.dart';
import '../../helper/flutter_flow/flutter_flow_theme.dart';
import '../../global/variables.dart';
import '../../helper/firestore_helper.dart';
import '../../models/patient.dart';
import '../patient_form_screen.dart';

class PatientScreen extends StatefulWidget {
  static const routeName = '/patient';
  const PatientScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PatientScreenState createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  final TextEditingController _patientNameController = TextEditingController();
  List<Patient> patients = [];

  Patient? getPatient(int id) {
    return patients.firstWhere((patient) => patient.id == id);
  }

  @override
  void initState() {
    super.initState();

    _loadData().then((value) {
      setState(() {
        patients = value;
        for (var patient in patients) {
          checkboxState[patient.id] = false;
        }
      });
    });
  }

  Future<List<Patient>> _loadData() async {
    // Load the data asynchronously
    final data = await loadPatientsFromFirestore();

    // Return the loaded data
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          backgroundColor: appBackgroundColor,
          foregroundColor: appForegroundColor,
          automaticallyImplyLeading: false,
          actions: const [],
          flexibleSpace: FlexibleSpaceBar(
            title: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 14),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: Align(
                            alignment: AlignmentDirectional(0.00, 0.00),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
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
                      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Curamus Back-Office',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                          ),
                          Flexible(
                            child: Align(
                              alignment: AlignmentDirectional(1.00, 0.00),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                child: FlutterFlowIconButton(
                                  borderColor: Colors.transparent,
                                  borderRadius: 30,
                                  borderWidth: 1,
                                  buttonSize: 50,
                                  icon: Icon(
                                    Icons.dehaze_sharp,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () async {
                                    // context.pushNamed('settings');
                                  },
                                ),
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
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DataTable(
            columnSpacing: (MediaQuery.of(context).size.width / 10) * 0.5,
            dataRowHeight: 80,
            headingRowHeight: 0,
            showCheckboxColumn: false,
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  '',
                ),
              ),
              DataColumn(
                label: Text(
                  '',
                ),
              ),
              DataColumn(
                label: Text(
                  '',
                ),
              ),
            ],
            rows: patients
                .map((Patient patient) => DataRow(
                      onSelectChanged: (bool? selected) {
                        if (selected == true) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  PatientFormScreen(patient: patient)));
                        }
                      },
                      cells: <DataCell>[
                        DataCell(
                          Checkbox(
                            value: checkboxState[patient.id],
                            onChanged: (bool? value) {
                              setState(() {
                                checkboxState[patient.id] = value!;
                              });
                            },
                          ),
                        ),
                        DataCell(Text(patient.name)),
                        DataCell(
                            Text(DateFormat.yMMMd().format(patient.startDate))),
                      ],
                    ))
                .toList(),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(icon: Icons.create, children: [
        SpeedDialChild(
          child: const Icon(Icons.add),
          label: 'Add Patient',
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text('Add Patient'),
                      content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextFormField(
                              controller: _patientNameController,
                              decoration: const InputDecoration(
                                  labelText: 'Patient Name'),
                            ),
                          ]),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Add'),
                          onPressed: () {
                            addPatient(_patientNameController.text.toString());
                            _patientNameController.clear();
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ));
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.delete),
          label: 'Delete Patient(s)',
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text('Delete Patient(s)'),
                      content: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                                'Are you sure you want to delete the selected patient(s)?'),
                          ]),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Delete'),
                          onPressed: () {
                            var keysToRemove = [];
                            for (var id in checkboxState.keys) {
                              if (checkboxState[id] == true) {
                                if (getPatient(id) != null) {
                                  keysToRemove.add(id);
                                }
                              }
                            }
                            setState(() {
                              for (var id in keysToRemove) {
                                removePatient(id);
                              }
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ));
          },
        ),
      ]),
    );
  }

  void addPatient(String string) {
    Patient patient = Patient(
      id: patients.length + 1,
      startDate: DateTime.now(),
      name: string,
      careTasks: [],
    );
    patients.add(patient);
    checkboxState[patient.id] = false;
    addPatientToDb(patient);
  }

  void removePatient(int id) {
    checkboxState.remove(id);
    patients.removeWhere((patient) => patient.id == id);
    removePatientFromDb(id);
  }
}
