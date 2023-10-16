import 'package:flutter/material.dart';
import 'package:todoapp/providers/patients_table_screen.dart';
import '../../main.dart';
import '../../main.dart';

class PatientScreen extends StatefulWidget {
  static const routeName = '/patient';
  const PatientScreen({super.key});

  @override
  _PatientScreenState createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Caretaker app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PatientTable(patients: patients),
              const SizedBox(
                height: 10,
              ),
              // TaskBuilder(filter: 'NoGroup'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              //todo
            });
          },
          child: Icon(Icons.delete),
        ));
  }

  Widget textDecoration(String text, BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      margin: const EdgeInsets.only(left: 10, bottom: 10),
      width: isLandscape
          ? mediaQuery.size.width * 0.2
          : mediaQuery.size.width * 0.4,
      height: isLandscape
          ? mediaQuery.size.width * 0.06
          : mediaQuery.size.height * 0.06,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: mediaQuery.textScaleFactor * 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
