import 'package:flutter/material.dart';
import 'package:todoapp/global/variables.dart';
import 'package:todoapp/helper/datetime_helper.dart';
import 'package:todoapp/helper/firestore_helper.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_theme.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_util.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_widgets.dart';
import 'package:todoapp/helper/monthly_picker.dart';
import 'package:todoapp/models/care_task.dart';
import 'package:todoapp/models/event_log.dart';
import 'package:todoapp/models/patient.dart';
import 'package:todoapp/screens/home_page.dart';
import 'package:todoapp/screens/tasks_and_logs/caretask_screen.dart';
import 'package:todoapp/widget/custom_app_bar.dart';

class CareTasksForm extends StatefulWidget {
  final Patient patient;
  final int caretaskIndex;
  final bool modifying;
  final bool isClickedDirectly;

  const CareTasksForm({
    super.key,
    required this.patient,
    required this.caretaskIndex,
    required this.modifying,
    required this.isClickedDirectly,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CareTasksFormState createState() => _CareTasksFormState();
}

class _CareTasksFormState extends State<CareTasksForm> {
  String title = 'Add new care task';
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> list = <String>['weekly', 'monthly', 'daily', 'once'];
  String? dropdownValue = 'weekly';
  TimeOfDay selectedTime = TimeOfDay.now();

  late TextEditingController _nameController;
  late TextEditingController _dateController;

  String currentNameTextFormFieldValue = '';
  String? frequencyCurrentFieldValue = '';

  saveToDb() {
    getDocumentID(widget.patient.id, 'patients').then((docID) {
      updatePatient(widget.patient, docID);
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.modifying) title = 'Modify care task';
    _nameController = TextEditingController();
    _dateController = TextEditingController();
    selectedDateTimeWhenAdding = DateTime.now().toString();
    _dateController.text = widget.modifying
        ? widget.patient.careTasks[widget.caretaskIndex].date
        : selectedDateTime;

    _nameController.text = widget.modifying
        ? widget.patient.careTasks[widget.caretaskIndex].taskName
        : currentNameTextFormFieldValue;

    frequencyCurrentFieldValue = widget.modifying
        ? widget.patient.careTasks[widget.caretaskIndex].taskFrequency
            .toString()
        : dropdownValue;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> isDatePicked(BuildContext context, String initialDateString,
      Frequency selectedModifier, bool isModifying, bool isClickedDirectly,
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
            _dateController.text = selectedDateTime;
            saveToDb();
          }
          if (!isModifying) {
            selectedDateTimeWhenAdding = selectedDateTime;
            _dateController.text = selectedDateTime;
          }
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
              _dateController.text = selectedDateTime;
              saveToDb();
            }
            if (!isModifying) {
              selectedDateTimeWhenAdding = selectedDateTime;
              _dateController.text = selectedDateTime;
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
            _dateController.text = selectedDateTime;
            saveToDb();
          }
          if (!isModifying) {
            selectedDateTimeWhenAdding = selectedDateTime;
            _dateController.text = selectedDateTime;
          }
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
              _dateController.text = selectedDateTime;
              saveToDb();
            }
            if (!isModifying) {
              selectedDateTimeWhenAdding = selectedDateTime;
              _dateController.text = selectedDateTime;
            }
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
            Navigator.of(context).pop(MaterialPageRoute(
                builder: (context) => CareTasksPage(
                      patient: widget.patient,
                    )));
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
                            title,
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
                            labelText: 'Care task Name',
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
                              saveToDb();
                            });
                          },
                          onTapOutside: (newValue) {
                            saveTextValue(
                                currentNameTextFormFieldValue, _nameController,
                                (value) {
                              if (widget.modifying) {
                                widget.patient.careTasks[widget.caretaskIndex]
                                    .taskName = value;
                                saveToDb();
                              }
                            }, () {});
                            FocusScope.of(context).unfocus();
                          },
                          onFieldSubmitted: (String newValue) {
                            saveTextValue(
                                currentNameTextFormFieldValue, _nameController,
                                (value) {
                              if (widget.modifying) {
                                widget.patient.careTasks[widget.caretaskIndex]
                                    .taskName = value;
                              }
                              saveToDb();
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
                          onChanged: (value) async {
                            if (value != dropdownValue) {
                              bool result = await isDatePicked(
                                  context,
                                  widget.patient.careTasks[widget.caretaskIndex]
                                      .date,
                                  Frequency.values.byName(value!),
                                  widget.modifying,
                                  widget.isClickedDirectly,
                                  index: widget.caretaskIndex);
                              if (result == true) {
                                setState(() {
                                  dropdownValue = value;
                                  if (widget.modifying) {
                                    widget
                                            .patient
                                            .careTasks[widget.caretaskIndex]
                                            .taskFrequency =
                                        Frequency.values.byName(value);
                                    saveToDb();
                                  }
                                });
                              }
                            }
                          },
                        ),
                        TextFormField(
                          onTap: () => {
                            widget.modifying
                                ? isDatePicked(
                                    context,
                                    widget.patient
                                        .careTasks[widget.caretaskIndex].date,
                                    widget
                                        .patient
                                        .careTasks[widget.caretaskIndex]
                                        .taskFrequency,
                                    widget.modifying,
                                    widget.isClickedDirectly,
                                    index: widget.caretaskIndex)
                                : isDatePicked(
                                    context,
                                    DateTime.now().toString(),
                                    Frequency.values
                                        .byName(dropdownValue.toString()),
                                    widget.modifying,
                                    widget.isClickedDirectly,
                                    index: -1)
                          },
                          keyboardType: TextInputType.datetime,
                          controller: _dateController,
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
                              if (_nameController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please enter a name for the care task'),
                                  ),
                                );
                                return;
                              }
                              widget.patient.careTasks.add(CareTask(
                                  taskName: _nameController.text,
                                  taskFrequency: Frequency.values
                                      .byName(dropdownValue.toString()),
                                  date: selectedDateTimeWhenAdding));
                              saveToDb();
                            } else {
                              widget.patient.careTasks
                                  .removeAt(widget.caretaskIndex);
                              saveToDb();
                            }
                            List<EventLog> tasks =
                                await loadEventLogsFromFirestore(
                                    widget.patient.id, Caller.patient);
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CareTasksPage(
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
