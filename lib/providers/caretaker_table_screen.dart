import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../global/variables.dart';
import '../models/caretaker.dart';
import '../screens/caretaker_form_screen.dart';

class CaretakerTable extends StatefulWidget {
  const CaretakerTable({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CaretakerTableState createState() => _CaretakerTableState();
}

class _CaretakerTableState extends State<CaretakerTable> {
  List<Caretaker> caretakers = [];

  @override
  void initState() {
    super.initState();
    _loadData().then((value) {
      setState(() {
        caretakers = value;
        for (var caretaker in caretakers) {
          checkboxState[caretaker.id] = false;
        }
      });
    });
  }

  Future<List<Caretaker>> _loadData() async {
    // Load the data asynchronously
    final data = await loadCaretakersFromFirestore();
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                CaretakerFormScreen(caretaker: caretaker)));
                      }
                    },
                    cells: <DataCell>[
                      DataCell(
                        Checkbox(
                          value: checkboxState[caretaker.id],
                          onChanged: (bool? value) {
                            setState(() {
                              checkboxState[caretaker.id] = value!;
                            });
                          },
                        ),
                      ),
                      DataCell(Text(caretaker.name)),
                      DataCell(
                          Text(DateFormat.yMMMd().format(caretaker.startDate))),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }

  Future<List<Caretaker>> loadCaretakersFromFirestore() async {
    List<Caretaker> caretakers = [];
    QuerySnapshot querySnapshot = await db.collection('caretakers').get();

    for (var doc in querySnapshot.docs) {
      caretakers.add(Caretaker(
        id: doc['id'],
        name: doc['name'],
        startDate: doc['startDate'].toDate(),
      ));
    }

    return caretakers;
  }
}
