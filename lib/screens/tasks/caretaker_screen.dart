import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../global/variables.dart';
import '../../providers/caretaker_table_screen.dart';

class CaretakerScreen extends StatefulWidget {
  static const routeName = '/caretaker';
  const CaretakerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CaretakerScreenState createState() => _CaretakerScreenState();
}

class _CaretakerScreenState extends State<CaretakerScreen> {
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
            CaretakerTable(),
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
          label: 'Add Caretaker',
          onTap: () {/* Do someting */},
        ),
        SpeedDialChild(
          child: const Icon(Icons.delete),
          label: 'Delete Caretaker(s)',
          onTap: () {/* Do something */},
        ),
      ]),
    );
  }
}
