import 'package:flutter/material.dart';
import '../../global/variables.dart';
import '../../helper/firestore_helper.dart';
import '../../models/event_log.dart';
import '../home_page.dart';

class EventLogScreen extends StatefulWidget {
  final List<EventLog> eventLogs;
  final String eventLogName;
  final Caller caller;
  const EventLogScreen(
      {super.key,
      required this.eventLogs,
      required this.eventLogName,
      required this.caller});

  @override
  _EventLogScreenState createState() => _EventLogScreenState();
}

class _EventLogScreenState extends State<EventLogScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  String currentTextFormFieldValue = '';

  DateTime _selectedDate = DateTime.now();

  int _editIndex = -1;
  String _editKey = '';
  String? _nameDropdownValue = 'Do Laundry';

  final FocusNode _focusNode = FocusNode();
  late List<String> list = [];

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      setState(() {
        if (_editIndex != -1) {
          if (_descriptionController.text.isNotEmpty) {
            widget.eventLogs[int.parse(_editKey)].description =
                _descriptionController.text;
            widget.eventLogs[int.parse(_editKey)].name = _nameDropdownValue!;
            _editIndex = -1;
            _editKey = '';
            _descriptionController.clear();
          } else {
            _descriptionController.text = _editKey;
          }
          _editIndex = -1;
          _editKey = '';
          _descriptionController.clear();
        }
      });
      saveToDb();
    }
  }

  @override
  void initState() {
    if (widget.caller == Caller.patient) {
      _loadData().then((value) {
        setState(() {
          list = value;
        });
      });
      list.add('Other');
    }
    super.initState();

    _focusNode.addListener(_onFocusChange);
  }

  Future<List<String>> _loadData() async {
    // Load the data asynchronously
    final data =
        await getCareTaskNamesFromPatientId(widget.eventLogs[0].patientId);

    // Return the loaded data
    return data;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          FocusScope.of(context).unfocus();
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.eventLogName),
          backgroundColor: appBackgroundColor,
          foregroundColor: appForegroundColor,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: ListView.builder(
            itemCount: widget.eventLogs.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_editIndex == -1) {
                            _editIndex = index;
                            _editKey = index.toString();
                            _descriptionController.text = widget
                                .eventLogs[int.parse(_editKey)].description;
                            _nameDropdownValue =
                                widget.eventLogs[int.parse(_editKey)].name;
                          }
                        });
                      },
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _editIndex = index;
                            _editKey = index.toString();
                            _descriptionController.text = widget
                                .eventLogs[int.parse(_editKey)].description;
                            _nameDropdownValue =
                                widget.eventLogs[int.parse(_editKey)].name;
                          });
                          _focusNode.requestFocus();
                        },
                        title: _editIndex == index
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _editIndex = index;
                                    _editKey = index.toString();
                                    _descriptionController.text = widget
                                        .eventLogs[int.parse(_editKey)]
                                        .description;
                                    _nameDropdownValue = widget
                                        .eventLogs[int.parse(_editKey)].name;
                                  });
                                  _focusNode.requestFocus();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 20),
                                  child: SizedBox(
                                      width: 130,
                                      child: DropdownMenu<String>(
                                        initialSelection: _nameDropdownValue,
                                        label: const Text('Task Name'),
                                        requestFocusOnTap: false,
                                        onSelected: (String? newValue) {
                                          setState(() {
                                            String index =
                                                _editIndex.toString();
                                            _nameDropdownValue = newValue!;
                                            widget.eventLogs[int.parse(index)]
                                                .name = _nameDropdownValue!;
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
                                ))
                            : GestureDetector(
                                child: Text(widget.eventLogs[index].name),
                              ),
                        subtitle: _editIndex == index
                            ? TextFormField(
                                focusNode: _focusNode,
                                controller: _descriptionController,
                                onChanged: (String newValue) {
                                  setState(() {
                                    currentTextFormFieldValue = newValue;
                                  });
                                },
                                onTapOutside: (newValue) {
                                  if (currentTextFormFieldValue.isNotEmpty) {
                                    widget.eventLogs[int.parse(_editKey)]
                                            .description =
                                        currentTextFormFieldValue;
                                  }
                                  saveToDb();
                                },
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _editIndex = index;
                                    _editKey = index.toString();
                                    _descriptionController.text = widget
                                        .eventLogs[int.parse(_editKey)]
                                        .description;
                                    _focusNode.requestFocus();
                                  });
                                },
                                child:
                                    Text(widget.eventLogs[index].description),
                              ),
                        trailing: _editIndex == index
                            ? IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: () {
                                  setState(() {
                                    _editIndex = -1;
                                    _editKey = '';
                                    _descriptionController.clear();
                                  });
                                },
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FloatingActionButton.extended(
                                    label: Text(
                                      widget.eventLogs[index].date.toString(),
                                    ),
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: () => {
                                      _selectDate(context, index),
                                      widget.eventLogs[index].date =
                                          _selectedDate,
                                      print('todo save'),
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        widget.eventLogs.removeAt(index);
                                        print('todo delete from db');
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
            _descriptionController.clear();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Add New Care Task'),
                  content:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Event Log'),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: DropdownMenu<String>(
                          width: 202,
                          initialSelection: _nameDropdownValue,
                          label: const Text('Event Log Name'),
                          onSelected: (String? newValue) {
                            setState(() {
                              _nameDropdownValue = newValue!;
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
                          label: Text(selectedDateTime),
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => {
                            _selectDate(context, -1),
                          },
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
                        if (_descriptionController.text.isNotEmpty) {
                          setState(() {
                            widget.eventLogs.add(EventLog(
                              id: (widget.eventLogs.length + 1).toString(),
                              description: _descriptionController.text,
                              name: _nameDropdownValue!,
                              date: _selectedDate,
                              patientId: '1',
                              caretakerId: '1',
                            ));
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

  Future<void> _selectDate(BuildContext context, int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(picked),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
        if (index != -1) {
          widget.eventLogs[index].date = _selectedDate;
          saveToDb();
        }
      }
    }
  }

  void saveToDb() {
    // Implement the logic to save the updated patient to the database
    print("saveToDb function");
  }
}
