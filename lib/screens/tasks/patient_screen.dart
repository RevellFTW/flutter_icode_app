import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:todoapp/providers/patients_table_screen.dart';

import '../../global/variables.dart';
import '../../helper/firestore_helper.dart';
import '../../models/patient.dart';

class PatientScreen extends StatefulWidget {
  static const routeName = '/patient';
  const PatientScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PatientScreenState createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  final TextEditingController _patientNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        backgroundColor: appBackgroundColor,
        foregroundColor: appForegroundColor,
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PatientTable(),
            SizedBox(
              height: 10,
            ),
            // TaskBuilder(filter: 'NoGroup'),
          ],
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
                      title: Text('Add Patient'),
                      content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextFormField(
                              controller: _patientNameController,
                              decoration:
                                  InputDecoration(labelText: 'Patient Name'),
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
          onTap: () {/* Do something */},
        ),
      ]),
    );
  }
}
