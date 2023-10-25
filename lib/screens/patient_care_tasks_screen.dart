import 'dart:collection';

import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/models/care_task.dart';
import '../helper/firestore_helper.dart';
import '../main.dart';
import '../models/patient.dart';
import '../helper/datetime_helper.dart';

class CareTasksPage extends StatefulWidget {
  final Patient patient;
  const CareTasksPage({super.key, required this.patient});

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
      updatePatient(widget.patient, docID);
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
            widget.patient.careTasks[int.parse(_editKey)].taskName =
                _taskController.text;
            widget.patient.careTasks[int.parse(_editKey)].taskFrequency =
                Frequency.values.byName(dropdownValue!);
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

  Future<void> pickDate(BuildContext context, DateTime initialDateTime,
      {int index = -1}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
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
      if (index != -1) {
        pickTime(context, index: index);
      } else {
        pickTime(context);
      }
    }
  }

  Future<void> pickTime(BuildContext context, {int index = -1}) async {
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
        if (index != -1) {
          widget.patient.careTasks[index].date = selectedDateTime;
          saveToDb();
        }
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
            itemCount: widget.patient.careTasks.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_editIndex == -1) {
                            _editIndex = index;
                            _editKey = index.toString();
                            _taskController.text = widget.patient
                                .careTasks[int.parse(_editKey)].taskName!;
                            dropdownValue = widget
                                .patient
                                .careTasks[int.parse(_editKey)]
                                .taskFrequency
                                .name
                                .toString();
                          }
                        });
                      },
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _editIndex = index;
                            _editKey = index.toString();
                            _taskController.text = widget.patient
                                .careTasks[int.parse(_editKey)].taskName;
                            dropdownValue = widget
                                .patient
                                .careTasks[int.parse(_editKey)]
                                .taskFrequency
                                .name
                                .toString();
                          });
                          _focusNode.requestFocus();
                        },
                        title: _editIndex == index
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _editIndex = index;
                                    _editKey = index.toString();
                                    _taskController.text = widget
                                        .patient
                                        .careTasks[int.parse(_editKey)]
                                        .taskName;
                                    dropdownValue = widget
                                        .patient
                                        .careTasks[int.parse(_editKey)]
                                        .taskFrequency
                                        .name
                                        .toString();
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
                                      widget
                                          .patient
                                          .careTasks[int.parse(_editKey)]
                                          .taskName = currentTextFormFieldValue;
                                    }
                                    saveToDb();
                                  },
                                ),
                              )
                            : GestureDetector(
                                child: Text(
                                    widget.patient.careTasks[index].taskName),
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
                                          String index = _editIndex.toString();
                                          dropdownValue = newValue!;
                                          widget
                                                  .patient
                                                  .careTasks[int.parse(index)]
                                                  .taskFrequency =
                                              Frequency.values
                                                  .byName(dropdownValue!);
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
                                    _editKey = index.toString();
                                    _taskController.text = widget
                                        .patient
                                        .careTasks[int.parse(_editKey)]
                                        .taskName;
                                    _focusNode.requestFocus();
                                  });
                                },
                                child: Text(
                                  widget.patient.careTasks[index].taskFrequency
                                      .name
                                      .toString(),
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
                                      DateFormat('MM-dd h:mm a').format(
                                          widget.patient.careTasks[index].date),
                                    ),
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: () => pickDate(context,
                                        widget.patient.careTasks[index].date,
                                        index: index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        widget.patient.careTasks
                                            .removeAt(index);
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
                          onPressed: () => pickDate(context, selectedDateTime),
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
                            widget.patient.careTasks.add(CareTask(
                                taskName: _taskController.text,
                                taskFrequency:
                                    Frequency.values.byName(dropdownValue!),
                                date: selectedDateTime));
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
