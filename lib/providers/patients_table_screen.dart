import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../global/variables.dart';
import '../helper/firestore_helper.dart';
import '../models/care_task.dart';
import '../models/patient.dart';
import '../screens/patient_form_screen.dart';

class PatientTable extends StatefulWidget {
  const PatientTable({Key? key}) : super(key: key);
  @override
  _PatientTableState createState() => _PatientTableState();

  setPatients(List<Patient> patients) {
    patients = patients;
  }
}

List<Patient> patients = [];

class _PatientTableState extends State<PatientTable> {
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
    return SingleChildScrollView(
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
                'Entry Date',
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
    );
  }

  Future<List<Patient>> loadPatientsFromFirestore() async {
    List<Patient> patients = [];
    QuerySnapshot querySnapshot = await db.collection('patients').get();

    for (var doc in querySnapshot.docs) {
      var careTasksCollection = doc['careTasks'];
      List<CareTask> careTasks = [];
      for (var map in careTasksCollection) {
        String date = DateTime.now().toString();
        Frequency frequency = Frequency.weekly;
        String taskName = 'default';
        map.forEach((key, value) {
          switch (key) {
            case 'date':
              {
                date = date;
              }
              break;
            case 'frequency':
              {
                frequency = Frequency.values.byName(value);
              }
            case 'task':
              {
                taskName = value;
              }
          }
        });
        careTasks.add(
            CareTask(taskName: taskName, taskFrequency: frequency, date: date));
      }

      patients.add(Patient(
          id: doc['id'],
          name: doc['name'],
          startDate: doc['startDate'].toDate(),
          careTasks: careTasks));
    }

    return patients;
  }
}

void addPatient(String string) async {
  Patient patient = Patient(
    id: patients.length + 1,
    startDate: DateTime.now(),
    name: string,
    careTasks: [],
  );
  patients.add(patient);
  addPatientToDb(patient);
}
