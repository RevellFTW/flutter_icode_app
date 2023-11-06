import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
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
      appBar: AppBar(
        title: Text(appName),
        backgroundColor: appBackgroundColor,
        foregroundColor: appForegroundColor,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DataTable(
            showCheckboxColumn: false,
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'Select',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Name',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Date of admission',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
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
