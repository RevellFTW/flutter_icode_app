import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../helper/firestore_helper.dart';
import '../main.dart';
import '../models/patient.dart';
import '../helper/datetime_helper.dart';

class CareTasksPage extends StatefulWidget {
  final Map<String, Map<String, String>> careTasks;

  final Patient patient;
  const CareTasksPage(
      {super.key, required this.careTasks, required this.patient});

  @override
  // ignore: library_private_types_in_public_api
  _CareTasksPageState createState() => _CareTasksPageState();
}

class _CareTasksPageState extends State<CareTasksPage> {
  final List<String> list = <String>['weekly', 'monthly', 'daily', 'once'];
  final TextEditingController _taskController = TextEditingController();
  int _editIndex = -1;
  int _editFrequency = -1;
  String _editKey = '';
  String? dropdownValue = 'weekly';
  final FocusNode _focusNode = FocusNode();
  String currentTextFormFieldValue = '';

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
            //widget.careTasks.remove(_editKey);
            widget.careTasks[_editKey]!['task'] = _taskController.text;
            widget.careTasks[_editKey]!['frequency'] = dropdownValue!;
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
          backgroundColor: appBackgroundColor,
          foregroundColor: appForegroundColor,
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
                      key: ValueKey(widget.careTasks.keys.elementAt(index)),
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: _editIndex == index
                                ? TextFormField(
                                    focusNode: _focusNode,
                                    controller: _taskController,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        currentTextFormFieldValue = newValue;
                                      });
                                    },
                                    onTapOutside: (newValue) {
                                      setState(() {
                                        if (currentTextFormFieldValue
                                            .isNotEmpty) {
                                          //widget.careTasks.remove(_editKey);
                                          widget.careTasks[_editKey]!['task'] =
                                              currentTextFormFieldValue;
                                        }
                                        _editIndex = -1;
                                        _editKey = '';
                                        _taskController.clear();
                                        _focusNode.unfocus();
                                        saveToDb();
                                      });
                                    },
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (_editIndex == -1) {
                                          _editIndex = index;
                                          _editKey = widget.careTasks.keys
                                              .elementAt(index);
                                          _taskController.text = widget
                                              .careTasks[_editKey]!['task']!;
                                          dropdownValue = widget.careTasks[
                                              _editKey]!['frequency'];
                                        } else {
                                          _editIndex = -1;
                                          _editKey = '';
                                          _taskController.clear();
                                        }
                                      });
                                    },
                                    child: Text(widget.careTasks[widget
                                        .careTasks.keys
                                        .elementAt(index)]!['task']!),
                                  ),
                            trailing: _editFrequency == index
                                ? SizedBox(
                                    width: 130,
                                    child: DropdownMenu<String>(
                                      initialSelection: dropdownValue,
                                      label:
                                          const Text('Frequency of Care Task'),
                                      hintText: 'weekly, monthly, daily',
                                      onSelected: (String? newValue) {
                                        setState(() {
                                          String index = widget.careTasks.keys
                                              .elementAt(_editFrequency);
                                          dropdownValue = newValue!;
                                          widget.careTasks[index]![
                                              'frequency'] = dropdownValue!;

                                          _editFrequency = -1;
                                          _editKey = '';
                                          _focusNode.unfocus();
                                        });
                                        saveToDb();
                                      },
                                      dropdownMenuEntries: list
                                          .map<DropdownMenuEntry<String>>(
                                              (String value) {
                                        return DropdownMenuEntry<String>(
                                            value: value, label: value);
                                      }).toList(),
                                    ))
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _editFrequency = index;
                                      });
                                    },
                                    child: Text(
                                      widget.careTasks[widget.careTasks.keys
                                          .elementAt(index)]!['frequency']!,
                                    ),
                                  ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              String keyToRemove =
                                  widget.careTasks.keys.elementAt(index);
                              widget.careTasks.remove(keyToRemove);
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
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: ElevatedButton(
                        onPressed: () => pickDate(context),
                        child: const Text('Pick Date'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: ElevatedButton(
                        onPressed: () => pickTime(context),
                        child: const Text('Pick Time'),
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
                            int index = widget.careTasks.length;
                            widget.careTasks[index.toString()] = {
                              'task': _taskController.text,
                              'frequency': dropdownValue!,
                            };
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
