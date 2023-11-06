import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/helper/firestore_helper.dart';
import '../../global/variables.dart';
import '../../models/caretaker.dart';
import '../caretaker_form_screen.dart';

class CaretakerScreen extends StatefulWidget {
  static const routeName = '/caretaker';
  const CaretakerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CaretakerScreenState createState() => _CaretakerScreenState();
}

class _CaretakerScreenState extends State<CaretakerScreen> {
  List<Caretaker> caretakers = [];
  final TextEditingController _caretakerNameController =
      TextEditingController();

  Caretaker? getCaretaker(int id) {
    return caretakers.firstWhere((caretaker) => caretaker.id == id);
  }

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
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        backgroundColor: appBackgroundColor,
        foregroundColor: appForegroundColor,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 10,
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
                  'Joining date',
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
                        DataCell(Text(
                            DateFormat.yMMMd().format(caretaker.startDate))),
                      ],
                    ))
                .toList(),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(icon: Icons.create, children: [
        SpeedDialChild(
          child: const Icon(Icons.add),
          label: 'Add Caretaker',
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text('Add Caretaker'),
                      content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextFormField(
                              controller: _caretakerNameController,
                              decoration: const InputDecoration(
                                  labelText: 'Caretaker Name'),
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
                            addCaretaker(
                                _caretakerNameController.text.toString());
                            _caretakerNameController.clear();
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ));
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.delete),
          label: 'Delete Caretaker(s)',
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text('Delete Caretaker(s)'),
                      content: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                                'Are you sure you want to delete the selected caretaker(s)?'),
                          ]),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Delete'),
                          onPressed: () {
                            var keysToRemove = [];
                            for (var id in checkboxState.keys) {
                              if (checkboxState[id] == true) {
                                if (getCaretaker(id) != null) {
                                  keysToRemove.add(id);
                                }
                              }
                            }
                            setState(() {
                              for (var id in keysToRemove) {
                                removeCaretaker(id);
                              }
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ));
          },
        ),
      ]),
    );
  }

  void addCaretaker(String string) {
    Caretaker caretaker = Caretaker(
      id: caretakers.length + 1,
      startDate: DateTime.now(),
      name: string,
      patients: [],
    );
    caretakers.add(caretaker);
    checkboxState[caretaker.id] = false;
    addCaretakerToDb(caretaker);
  }

  void removeCaretaker(int id) {
    checkboxState.remove(id);
    caretakers.removeWhere((caretaker) => caretaker.id == id);
    removeCaretakerFromDb(id);
  }
}
