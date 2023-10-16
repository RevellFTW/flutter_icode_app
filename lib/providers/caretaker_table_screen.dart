import 'package:flutter/material.dart';
import '../models/caretaker.dart';
import '../screens/caretaker_form_screen.dart';

class CaretakerTable extends StatelessWidget {
  final List<Caretaker> caretakers;

  const CaretakerTable({super.key, required this.caretakers});

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
          rows: caretakers
              .map((Caretaker caretaker) => DataRow(
                    onSelectChanged: (bool? selected) {
                      if (selected == true) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Edit Caretaker'),
                              content:
                                  CaretakerFormScreen(caretaker: caretaker),
                            );
                          },
                        );
                      }
                    },
                    cells: <DataCell>[
                      DataCell(Text(caretaker.name)),
                      DataCell(Text(caretaker.startDate.toString())),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }
}
