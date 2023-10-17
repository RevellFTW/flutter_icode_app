import 'package:flutter/material.dart';
import '../../models/patient.dart';
import '../../providers/patients_table_screen.dart';

class GroupScreen extends StatelessWidget {
  final String groupName;
  //fill patients with data
  final List<Patient> patients = List<Patient>.generate(
    20,
    (index) => Patient(
      id: index,
      name: 'Patient $index',
      startDate: DateTime.now(),
    ),
  );

  GroupScreen(this.groupName, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(groupName),
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Image.asset(
                  'assets/images/${groupName.toLowerCase()}.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            expandedHeight: 200,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: groupName.toLowerCase() == 'patients'
                  ? const PatientTable()
                  : const PatientTable(),
            ),
          ),
        ],
      ),
    );
  }
}
