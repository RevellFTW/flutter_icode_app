import 'package:flutter/material.dart';
import 'package:todoapp/global/variables.dart';
import 'package:todoapp/helper/firestore_helper.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_theme.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_util.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_widgets.dart';
import 'package:todoapp/helper/monthly_picker.dart';
import 'package:todoapp/models/care_task.dart';
import 'package:todoapp/models/event_log.dart';
import 'package:todoapp/models/patient.dart';
import 'package:todoapp/screens/home_page.dart';
import 'package:todoapp/screens/tasks_and_logs/event_log_screen.dart';
import 'package:todoapp/widget/custom_app_bar.dart';

class CareTasksForm extends StatefulWidget {
  final Patient patient;
  final int caretaskIndex;
  final bool modifying;

  const CareTasksForm({
    super.key,
    required this.patient,
    required this.caretaskIndex,
    required this.modifying,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CareTasksFormState createState() => _CareTasksFormState();
}

class _CareTasksFormState extends State<CareTasksForm> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> list = <String>['weekly', 'monthly', 'daily', 'once'];
  String? dropdownValue = 'weekly';
  TimeOfDay selectedTime = TimeOfDay.now();

  late TextEditingController _nameController;
  late TextEditingController _dateController;

  String currentNameTextFormFieldValue = '';

  saveToDb() {
    getDocumentID(widget.patient.id, 'patients').then((docID) {
      updatePatient(widget.patient, docID);
    });
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dateController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
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
        // ignore: use_build_context_synchronously
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
                    child: const Text('Monday'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop('Tuesday'),
                    child: const Text('Tuesday'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop('Wednesday'),
                    child: const Text('Wednesday'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop('Thursday'),
                    child: const Text('Thursday'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop('Friday'),
                    child: const Text('Friday'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop('Saturday'),
                    child: const Text('Saturday'),
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
      // ignore: use_build_context_synchronously
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: isClickedDirectly
            ? extractTimeFromInput(initialDateString)
            : TimeOfDay.now(),
      );

      if (pickedTime != null) {
        TimeOfDay time =
            TimeOfDay(hour: pickedTime.hour, minute: pickedTime.minute);
        // ignore: use_build_context_synchronously
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
        // ignore: use_build_context_synchronously
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: CustomAppBar(
          //todo make patient name dynamic
          title: 'Back to ${widget.patient.name}\'s sheet',
          onBackPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(-1.00, 0.00),
                          child: Text(
                            'Add new eventLog',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        TextFormField(
                          controller: _nameController,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Task Name',
                            labelStyle:
                                FlutterFlowTheme.of(context).labelMedium,
                            hintStyle: FlutterFlowTheme.of(context).labelMedium,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          onChanged: (String newValue) {
                            setState(() {
                              currentNameTextFormFieldValue = newValue;
                            });
                          },
                          onTapOutside: (newValue) {
                            saveTextValue(
                                currentNameTextFormFieldValue, _nameController,
                                (value) {
                              if (widget.modifying) {
                                widget.patient.careTasks[widget.caretaskIndex]
                                    .taskName = value;
                              }
                            }, () {});
                            FocusScope.of(context).unfocus();
                          },
                          onFieldSubmitted: (String newValue) {
                            saveTextValue(
                                currentNameTextFormFieldValue, _nameController,
                                (value) {
                              widget.patient.careTasks[widget.caretaskIndex]
                                  .taskName = value;
                            }, () {});
                          },
                        ),
                        DropdownButtonFormField(
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: 'Frequency',
                            labelStyle:
                                FlutterFlowTheme.of(context).labelMedium,
                            hintStyle: FlutterFlowTheme.of(context).labelMedium,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          value: list.first,
                          items: list.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              widget.patient.careTasks[widget.caretaskIndex]
                                      .taskFrequency =
                                  Frequency.values.byName(value.toString());
                              value;
                              //TODO handle different time picking based on selected frequency
                            });
                          },
                        ),
                        TextFormField(
                          onTap: () => widget.modifying
                              ? isDatePicked(
                                  setState,
                                  context,
                                  widget.patient.careTasks[widget.caretaskIndex]
                                      .date,
                                  widget.patient.careTasks[widget.caretaskIndex]
                                      .taskFrequency,
                                  true,
                                  true,
                                  index: widget.caretaskIndex)
                              : isDatePicked(
                                  setState,
                                  context,
                                  widget.patient.careTasks[widget.caretaskIndex]
                                      .date,
                                  widget.patient.careTasks[widget.caretaskIndex]
                                      .taskFrequency,
                                  false,
                                  false,
                                  index: widget.caretaskIndex),
                          //enabled: false,
                          keyboardType: TextInputType.datetime,
                          controller: _dateController,
                          // focusNode: _model.textFieldFocusNode2,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Date',
                            labelStyle:
                                FlutterFlowTheme.of(context).labelMedium,
                            hintStyle: FlutterFlowTheme.of(context).labelMedium,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          validator: (value) {
                            String pattern = r'^\d{2}/\d{2}/\d{4}$';
                            RegExp regex = RegExp(pattern);
                            if (!regex.hasMatch(value!)) {
                              return 'Invalid date format';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (String newValue) {
                            //ok
                          },
                          onTapOutside: (newValue) {
                            //ok
                          },
                          onFieldSubmitted: (String newValue) {
                            //ok
                          },
                        ),
                      ].divide(const SizedBox(height: 12)),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0.00, 0.00),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 34, 0, 12),
                      child: FFButtonWidget(
                        onPressed: () {
                          setState(() async {
                            if (!widget.modifying) {
                              //todo adding
                            } else {
                              //todo modify/delete
                            }
                            List<EventLog> tasks =
                                await loadEventLogsFromFirestore(
                                    widget.patient!.id);
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EventLogScreen(
                                      eventLogs: tasks,
                                      eventLogName:
                                          "${widget.patient!.name} Patient's Log",
                                      caller: Caller.patient,
                                      patient: widget.patient,
                                    )));
                          });
                        },
                        text: widget.modifying ? 'DELETE' : 'ADD',
                        options: FFButtonOptions(
                          width: 600,
                          height: 48,
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: widget.modifying
                              ? const Color(0xFFEFEFEF)
                              : FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Readex Pro',
                                    color: widget.modifying
                                        ? const Color(0xFFFF0800)
                                        : Colors.white,
                                  ),
                          elevation: 4,
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void saveTextValue(String currentFieldValue, TextEditingController controller,
      Function setAttribute, Function setControllerText) {
    if (currentFieldValue.isNotEmpty) {
      setState(() {
        setAttribute(currentFieldValue);
        if (widget.modifying) saveToDb();
      });
    } else {
      setState(() {
        setControllerText();
      });
    }
  }
}
