import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Future<void> pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 100),
    );
    if (pickedDate != null && pickedDate != selectedDateTime) {
      setState(() {
        selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          selectedDateTime.hour,
          selectedDateTime.minute,
        );
      });
      pickTime(context);
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );
    if (pickedTime != null) {
      setState(() {
        selectedDateTime = DateTime(
          selectedDateTime.year,
          selectedDateTime.month,
          selectedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          saveToDb();
          FocusScope.of(context).unfocus();
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.patient.name}'s Care Tasks"),
          backgroundColor: appBackgroundColor,
          foregroundColor: appForegroundColor,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: ListView.builder(
            itemCount: widget.careTasks.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_editIndex == -1) {
                            _editIndex = index;
                            _editKey = widget.careTasks.keys.elementAt(index);
                            _taskController.text =
                                widget.careTasks[_editKey]!['task']!;
                            dropdownValue =
                                widget.careTasks[_editKey]!['frequency'];
                          }
                        });
                      },
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _editIndex = index;
                            _editKey = widget.careTasks.keys.elementAt(index);
                            _taskController.text =
                                widget.careTasks[_editKey]!['task']!;
                            dropdownValue =
                                widget.careTasks[_editKey]!['frequency'];
                          });
                          _focusNode.requestFocus();
                        },
                        title: _editIndex == index
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _editIndex = index;
                                    _editKey =
                                        widget.careTasks.keys.elementAt(index);
                                    _taskController.text =
                                        widget.careTasks[_editKey]!['task']!;
                                    dropdownValue = widget
                                        .careTasks[_editKey]!['frequency'];
                                  });
                                  _focusNode.requestFocus();
                                },
                                child: TextFormField(
                                  focusNode: _focusNode,
                                  controller: _taskController,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      currentTextFormFieldValue = newValue;
                                    });
                                  },
                                  onTapOutside: (newValue) {
                                    if (currentTextFormFieldValue.isNotEmpty) {
                                      widget.careTasks[_editKey]!['task'] =
                                          currentTextFormFieldValue;
                                    }
                                    saveToDb();
                                  },
                                ),
                              )
                            : GestureDetector(
                                child: Text(widget.careTasks[widget
                                    .careTasks.keys
                                    .elementAt(index)]!['task']!),
                              ),
                        subtitle: _editIndex == index
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                child: SizedBox(
                                    width: 130,
                                    child: DropdownMenu<String>(
                                      initialSelection: dropdownValue,
                                      label: const Text('Frequency'),
                                      requestFocusOnTap: false,
                                      onSelected: (String? newValue) {
                                        setState(() {
                                          String index = widget.careTasks.keys
                                              .elementAt(_editIndex);
                                          dropdownValue = newValue!;
                                          widget.careTasks[index]![
                                              'frequency'] = dropdownValue!;

                                          _editIndex = -1;
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
                                    )),
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _editIndex = index;
                                    _editKey =
                                        widget.careTasks.keys.elementAt(index);
                                    _taskController.text =
                                        widget.careTasks[_editKey]!['task']!;
                                    _focusNode.requestFocus();
                                  });
                                },
                                child: Text(
                                  widget.careTasks[widget.careTasks.keys
                                      .elementAt(index)]!['frequency']!,
                                ),
                              ),
                        trailing: _editIndex == index
                            ? IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: () {
                                  setState(() {
                                    _editIndex = -1;
                                    _editKey = '';
                                    _taskController.clear();
                                  });
                                },
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FloatingActionButton.extended(
                                    label: Text(
                                      DateFormat('MM-dd h:mm a')
                                          .format(selectedDateTime),
                                    ),
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: () => pickDate(context),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        widget.careTasks.remove(widget
                                            .careTasks.keys
                                            .elementAt(index));
                                        saveToDb();
                                      });
                                    },
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              );
            },
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
                  content:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    TextFormField(
                      controller: _taskController,
                      decoration: const InputDecoration(labelText: 'Care Task'),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: DropdownMenu<String>(
                          width: 202,
                          initialSelection: dropdownValue,
                          label: const Text('Frequency'),
                          onSelected: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          dropdownMenuEntries: list
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          }).toList(),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: FloatingActionButton.extended(
                          label: Text(
                            DateFormat('yyyy-MM-dd h:mm a')
                                .format(selectedDateTime),
                          ),
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => pickDate(context),
                        ),
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
