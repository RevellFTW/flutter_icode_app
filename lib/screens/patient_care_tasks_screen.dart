import 'dart:collection';

import 'package:flutter/material.dart';
import '../helper/firestore_helper.dart';
import '../models/patient.dart';

class CareTasksPage extends StatefulWidget {
  final HashMap<String, String> careTasks;

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
  int _editFrequency = -1;
  String _editKey = '';
  String? dropdownValue = 'weekly';
  final FocusNode _focusNode = FocusNode();
  Map<int, String> orderedCareTasks = {};

  saveToDb() {
    getDocumentID(widget.patient.id).then((docID) {
      addDocumentToCareTasks(widget.careTasks, docID);
    });
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      setState(() {
        if (_editIndex != -1) {
          if (_taskController.text.isNotEmpty) {
            widget.careTasks.remove(_editKey);
            widget.careTasks[_taskController.text] = dropdownValue!;
            orderedCareTasks[_editIndex] = _taskController.text;
            _editIndex = -1;
            _editKey = '';
            _taskController.clear();
          } else {
            _taskController.text = _editKey;
          }
          _editIndex = -1;
          _editKey = '';
          _taskController.clear();
        }
      });
      saveToDb();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        saveToDb();
        FocusScope.of(context)
            .unfocus(); // Unfocus the TextField and DropdownButtonFormField
      },
      child: Scaffold(
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
                                    focusNode: _focusNode,
                                    controller: _taskController,
                                    onSubmitted: (newValue) {
                                      setState(() {
                                        if (newValue.isNotEmpty) {
                                          widget.careTasks.remove(_editKey);
                                          widget.careTasks[newValue] =
                                              dropdownValue!;
                                          orderedCareTasks[_editIndex] =
                                              _taskController.text;
                                        }
                                        _editIndex = -1;
                                        _editKey = '';
                                        _taskController.clear();
                                        _focusNode.unfocus();
                                      });
                                      saveToDb();
                                    },
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (_editIndex == -1) {
                                          _editIndex = index;
                                          _editKey = widget.careTasks.keys
                                              .elementAt(index);
                                          _taskController.text = _editKey;
                                          dropdownValue =
                                              widget.careTasks[_editKey];
                                        } else {
                                          _editIndex = -1;
                                          _editKey = '';
                                          _taskController.clear();
                                        }
                                      });
                                    },
                                    child: Text(
                                      widget.careTasks.keys.elementAt(index),
                                    ),
                                  ),
                            trailing: _editFrequency == index
                                ? SizedBox(
                                    width: 100,
                                    child: DropdownButtonFormField<String>(
                                      value: dropdownValue,
                                      decoration: const InputDecoration(
                                        labelText: 'Frequency of Care Task',
                                        hintText: 'weekly, monthly, daily',
                                      ),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownValue = newValue!;
                                          widget.careTasks[widget.careTasks.keys
                                                  .elementAt(index)] =
                                              dropdownValue!;
                                          _editFrequency = -1;
                                          _focusNode.unfocus();
                                        });
                                        saveToDb();
                                      },
                                      items: <String>[
                                        'weekly',
                                        'monthly',
                                        'daily'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ))
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _editFrequency = index;
                                      });
                                    },
                                    child: Text(
                                      widget.careTasks.values.elementAt(index),
                                    ),
                                  ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              widget.careTasks.remove(
                                  widget.careTasks.keys.elementAt(index));
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
      ),
    );
  }
}
