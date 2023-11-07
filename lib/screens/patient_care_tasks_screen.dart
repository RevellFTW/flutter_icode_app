import 'package:flutter/material.dart';
import 'package:todoapp/models/care_task.dart';
import '../global/variables.dart';
import '../helper/firestore_helper.dart';
import '../helper/monthly_picker.dart';
import '../models/patient.dart';
import 'package:intl/intl.dart';

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
  TimeOfDay selectedTime = TimeOfDay.now();
  final FocusNode _focusNode = FocusNode();
  String currentTextFormFieldValue = '';
  saveToDb() {
    getDocumentID(widget.patient.id, 'patients').then((docID) {
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

  DateTime yMHTAStringToDateTime(String date) {
    DateTime dateTime = DateFormat("yyyy-MM-dd hh:mm a").parse(date);
    return dateTime;
  }

  TimeOfDay extractTimeFromInput(String input) {
    // Extracts time portion (e.g., "Wednesday 12:00 PM") from the input
    List<String> parts = input.split(' ');
    String timeString = '${parts[1]} ${parts[2]}';
    return stringToTimeOfDay(timeString);
  }

  TimeOfDay stringToTimeOfDay(String time) {
    // Split the input string into hours, minutes, and AM/PM parts
    List<String> parts = time.split(' ');
    List<String> timeParts = parts[0].split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);

    // Determine whether it's AM or PM and adjust hours accordingly
    if (parts[1] == 'PM' && hours != 12) {
      hours += 12;
    } else if (parts[1] == 'AM' && hours == 12) {
      hours = 0;
    }

    // Create and return the TimeOfDay object
    return TimeOfDay(hour: hours, minute: minutes);
  }

//input is ike 12.10 12:00
  DateTime mHTAStringToDateTime(String date) {
    // Parse the string to DateTime
    DateTime dateTime = DateFormat("MM-dd hh:mm a").parse(date);

    return dateTime;
  }

  Future<bool> isDatePicked(
      StateSetter setState,
      BuildContext context,
      String initialDateString,
      Frequency selectedModifier,
      bool isModifying,
      bool isClickedDirectly,
      {int index = -1}) async {
    if (selectedModifier == Frequency.daily) {
      // For daily, only pick time
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: isClickedDirectly
            ? stringToTimeOfDay(initialDateString)
            : TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          TimeOfDay time =
              TimeOfDay(hour: pickedTime.hour, minute: pickedTime.minute);
          selectedDateTime = time.format(context);
          if (index != -1) {
            widget.patient.careTasks[index].date = selectedDateTime;

            saveToDb();
          }
          if (!isModifying) selectedDateTimeWhenAdding = selectedDateTime;
        });
        return true;
      }
      return false;
    } else if (selectedModifier == Frequency.once) {
      // For once, pick date and time
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: isClickedDirectly
            ? yMHTAStringToDateTime(initialDateString)
            : DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 100),
        lastDate: DateTime(DateTime.now().year + 100),
      );
      if (pickedDate != null) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(pickedDate),
        );
        if (pickedTime != null) {
          setState(() {
            selectedDateTime = DateFormat('yyyy-MM-dd h:mm a').format(DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            ));

            if (index != -1) {
              widget.patient.careTasks[index].date = selectedDateTime;
              saveToDb();
            }
            if (!isModifying) {
              selectedDateTimeWhenAdding = selectedDateTime;
            }
          });
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else if (selectedModifier == Frequency.weekly) {
      // For weekly, pick day of the week and time
      String selectedDay = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Day of the Week'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Here you can create buttons for each day of the week
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop('Monday'),
                    child: Text('Monday'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop('Tuesday'),
                    child: Text('Tuesday'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop('Wednesday'),
                    child: Text('Wednesday'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop('Thursday'),
                    child: Text('Thursday'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop('Friday'),
                    child: Text('Friday'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop('Saturday'),
                    child: Text('Saturday'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop('Sunday'),
                    child: const Text('Sunday'),
                  ),
                )
                // Add buttons for other days of the week
              ],
            ),
          );
        },
      );

      // Once the user selects a day, proceed to pick time
      if (selectedDay != null) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: isClickedDirectly
              ? extractTimeFromInput(initialDateString)
              : TimeOfDay.now(),
        );

        if (pickedTime != null) {
          TimeOfDay time =
              TimeOfDay(hour: pickedTime.hour, minute: pickedTime.minute);
          String formattedTime = '$selectedDay ${time.format(context)}';
          setState(() {
            selectedDateTime = formattedTime;

            if (index != -1) {
              widget.patient.careTasks[index].date = selectedDateTime;
              saveToDb();
            }
            if (!isModifying) selectedDateTimeWhenAdding = selectedDateTime;
          });
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else if (selectedModifier == Frequency.monthly) {
      // For monthly, pick month, day, and time
      DateTime? pickedDate = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MonthlyPicker(
              setState: setState,
              initialDate: isClickedDirectly
                  ? mHTAStringToDateTime(initialDateString)
                  : DateTime.now());
        },
      );
      if (pickedDate != null) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(pickedDate),
        );
        if (pickedTime != null) {
          setState(() {
            TimeOfDay time =
                TimeOfDay(hour: pickedTime.hour, minute: pickedTime.minute);
            selectedDateTime =
                '${pickedDate.month}-${pickedDate.day} ${time.format(context)}';

            if (index != -1) {
              widget.patient.careTasks[index].date = selectedDateTime;
              saveToDb();
            }
            if (!isModifying) selectedDateTimeWhenAdding = selectedDateTime;
          });
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }
    return false;
  }

// Helper function to get weekday from string
  int _getWeekdayFromString(String day) {
    switch (day) {
      case 'Monday':
        return DateTime.monday;
      case 'Tuesday':
        return DateTime.tuesday;
      case 'Wednesday':
        return DateTime.wednesday;
      case 'Thursday':
        return DateTime.thursday;
      case 'Friday':
        return DateTime.friday;
      case 'Saturday':
        return DateTime.saturday;
      case 'Sunday':
        return DateTime.sunday;
      default:
        return DateTime.monday;
    }
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
                                .careTasks[int.parse(_editKey)].taskName;
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
                                      initialSelection: widget
                                          .patient
                                          .careTasks[int.parse(_editKey)]
                                          .taskFrequency
                                          .name
                                          .toString(),
                                      label: const Text('Frequency'),
                                      requestFocusOnTap: false,
                                      onSelected: (String? newValue) async {
                                        String index = _editIndex.toString();
                                        if (newValue != dropdownValue) {
                                          bool result = await isDatePicked(
                                              setState,
                                              context,
                                              widget.patient
                                                  .careTasks[_editIndex].date,
                                              Frequency.values
                                                  .byName(newValue!),
                                              true,
                                              false,
                                              index: _editIndex);
                                          if (result == true) {
                                            setState(() {
                                              dropdownValue = newValue;
                                              widget
                                                      .patient
                                                      .careTasks[int.parse(index)]
                                                      .taskFrequency =
                                                  Frequency.values
                                                      .byName(newValue);
                                              _editIndex = -1;
                                              _editKey = '';
                                              _focusNode.unfocus();
                                              saveToDb();
                                            });
                                          } else {
                                            _editIndex = -1;
                                            _editKey = '';
                                            _focusNode.unfocus();
                                          }
                                        } else {
                                          _editIndex = -1;
                                          _editKey = '';
                                          _focusNode.unfocus();
                                        }
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
                                      widget.patient.careTasks[index].date,
                                    ),
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: () => isDatePicked(
                                        setState,
                                        context,
                                        widget.patient.careTasks[index].date,
                                        widget.patient.careTasks[index]
                                            .taskFrequency,
                                        true,
                                        true,
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
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return AlertDialog(
                      title: const Text('Add New Care Task'),
                      content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextFormField(
                              controller: _taskController,
                              decoration:
                                  const InputDecoration(labelText: 'Care Task'),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: DropdownMenu<String>(
                                  width: 202,
                                  initialSelection: dropdownValue,
                                  label: const Text('Frequency'),
                                  onSelected: (String? newValue) async {
                                    bool result = false;
                                    if (newValue != dropdownValue) {
                                      result = await isDatePicked(
                                          setState,
                                          context,
                                          DateTime.now().toString(),
                                          Frequency.values.byName(newValue!),
                                          false,
                                          false);
                                    }
                                    if (result == true) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                      });
                                    }
                                  },
                                  dropdownMenuEntries: list
                                      .map<DropdownMenuEntry<String>>(
                                          (String value) {
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
                                  onPressed: () {
                                    setState(() {
                                      isDatePicked(
                                          setState,
                                          context,
                                          DateTime.now().toString(),
                                          Frequency.values
                                              .byName(dropdownValue!),
                                          false,
                                          false);
                                    });
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
                            if (_taskController.text.isNotEmpty) {
                              setState(() {
                                widget.patient.careTasks.add(CareTask(
                                    taskName: _taskController.text,
                                    taskFrequency:
                                        Frequency.values.byName(dropdownValue!),
                                    date: selectedDateTime.toString()));
                              });
                              saveToDb();
                              stateSetter();
                              Navigator.of(context).pop();
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: const Text(
                                        'Please enter a name for the care task.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void stateSetter() {
    setState(() {});
  }
}
