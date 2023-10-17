import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/patient.dart';
import '../screens/patient_form_screen.dart';

class PatientTable extends StatefulWidget {
  const PatientTable({Key? key}) : super(key: key);

  @override
  _PatientTableState createState() => _PatientTableState();
}

class _PatientTableState extends State<PatientTable> {
  List<Patient> patients = [];

  @override
  void initState() {
    super.initState();
    _loadData().then((value) {
      setState(() {
        patients = value;
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
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Name',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Start Date',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: patients
              .map((Patient patient) => DataRow(
                    onSelectChanged: (bool? selected) {
                      if (selected == true) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Edit Patient'),
                              content: PatientFormScreen(patient: patient),
                            );
                          },
                        );
                      }
                    },
                    cells: <DataCell>[
                      DataCell(Text(patient.name)),
                      DataCell(Text(patient.startDate.toString())),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }

  Future<List<Patient>> loadPatientsFromFirestore() async {
    List<Patient> patients = [];
    QuerySnapshot querySnapshot = await db.collection('patients').get();

    for (var doc in querySnapshot.docs) {
      patients.add(Patient(
          id: doc['id'],
          name: doc['name'],
          startDate: doc['startDate'].toDate()));
    }

    return patients;
  }
}
