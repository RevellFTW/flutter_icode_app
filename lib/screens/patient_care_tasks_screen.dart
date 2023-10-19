import 'package:flutter/material.dart';
import 'package:todoapp/main.dart';
import '../helper/firestore_helper.dart';
import '../models/patient.dart';

class CareTasksPage extends StatefulWidget {
  final Map<String, String> careTasks;
  final Patient patient;
  const CareTasksPage(
      {super.key, required this.careTasks, required this.patient});

  @override
  // ignore: library_private_types_in_public_api
  _CareTasksPageState createState() => _CareTasksPageState();
}

class _CareTasksPageState extends State<CareTasksPage> {
  final TextEditingController _taskController = TextEditingController();
  int _editIndex = -1;
  String _editKey = '';
  String? dropdownValue = 'weekly';

  saveToDb() {
    getDocumentID(widget.patient.id).then((docID) {
      addDocumentToCareTasks(widget.careTasks, docID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.patient.name}'s Care Tasks"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.careTasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: _editIndex == index
                              ? TextField(
                                  controller: _taskController,
                                  onSubmitted: (newValue) {
                                    setState(() {
                                      if (newValue.isNotEmpty) {
                                        widget.careTasks.remove(_editKey);
                                        widget.careTasks[newValue] =
                                            dropdownValue!;
                                      }
                                      _editIndex = -1;
                                      _editKey = '';
                                      _taskController.clear();
                                    });
                                    saveToDb();
                                  },
                                )
                              : Text(
                                  '${widget.careTasks.keys.elementAt(index)}: ${widget.careTasks.values.elementAt(index)}'),
                          onTap: () {
                            setState(() {
                              if (_editIndex == -1) {
                                _editIndex = index;
                                _editKey =
                                    widget.careTasks.keys.elementAt(index);
                                _taskController.text = _editKey;
                                dropdownValue = widget.careTasks[_editKey];
                              } else {
                                _editIndex = -1;
                                _editKey = '';
                                _taskController.clear();
                              }
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            widget.careTasks
                                .remove(widget.careTasks.keys.elementAt(index));
                          });
                          saveToDb();
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _taskController.clear();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Add New Care Task'),
                content: Column(children: <Widget>[
                  TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(labelText: 'Care Task'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: DropdownButtonFormField<String>(
                      value: dropdownValue,
                      decoration: const InputDecoration(
                        labelText: 'Frequency of Care Task',
                        hintText: 'weekly, monthly, daily',
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>['weekly', 'monthly', 'daily']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ]),
                //insert here
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
                      if (_taskController.text.isNotEmpty) {
                        setState(() {
                          widget.careTasks[_taskController.text] =
                              dropdownValue!;
                        });
                        saveToDb();
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
