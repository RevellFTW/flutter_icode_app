import 'package:flutter/material.dart';
import '../models/patient.dart';

class PatientTable extends StatelessWidget {
  final List<Patient> patients;

  const PatientTable({super.key, required this.patients});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                    // Handle the tap event here.
                  },
                  cells: <DataCell>[
                    DataCell(Text(patient.name)),
                    DataCell(Text(patient.startDate.toString())),
                    DataCell(Text(patient.caretakerName)),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
