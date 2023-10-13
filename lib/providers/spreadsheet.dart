import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../screens/patient_form_screen.dart';

class PatientTable extends StatelessWidget {
  final List<Patient> patients;

  const PatientTable({super.key, required this.patients});

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
            DataColumn(
              label: Text(
                'Caretaker',
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
                      DataCell(Text(patient.caretakerName)),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }
}
