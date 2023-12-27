import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todoapp/helper/datetime_helper.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_icon_button.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_theme.dart';
import 'package:todoapp/models/caretaker.dart';
import 'package:todoapp/screens/forms/caretaker_form_screen.dart';
import 'package:todoapp/screens/forms/event_log_form_screen.dart';
import 'package:todoapp/screens/forms/patient_form_screen.dart';
import 'package:todoapp/widget/custom_app_bar.dart';
import '../../helper/firestore_helper.dart';
import '../../models/event_log.dart';
import '../../models/patient.dart';
import '../home_page.dart';

class EventLogScreen extends StatefulWidget {
  final List<EventLog> eventLogs;

  final String eventLogName;
  final Caller caller;
  final Patient? patient;
  final Caretaker? caretaker;
  const EventLogScreen(
      {super.key,
      required this.eventLogs,
      required this.eventLogName,
      required this.caller,
      this.patient,
      this.caretaker});

  @override
  // ignore: library_private_types_in_public_api
  _EventLogScreenState createState() => _EventLogScreenState();
}

class _EventLogScreenState extends State<EventLogScreen> {
  List<EventLog> _filteredEventLogs = [];
  final TextEditingController _descriptionController = TextEditingController();
  String currentTextFormFieldValue = '';

  DateTime _selectedDate = DateTime.now();

  String _editKey = '';
  String? selectedCaretakerId;
  String? selectedPatientId;

  ValueNotifier<DateTime> selectedDay = ValueNotifier<DateTime>(DateTime.now());
  ValueNotifier<DateTime> focusedDay = ValueNotifier<DateTime>(DateTime.now());

  CalendarFormat calendarFormat = CalendarFormat.week;

  final FocusNode _focusNode = FocusNode();
  late List<String> list = [];
  //late List<String> individualCareTaskslist = [];
  late Map<String, List<String>> individualCareTaskslistMap = {};
  late List<Caretaker> caretakerList = [];
  late List<Patient> patientList = [];

  @override
  void initState() {
    super.initState();

    if (widget.caller == Caller.patient) {
      _loadData(widget.patient!.id.toString()).then((value) {
        setState(() {
          list = value;
          list.add('Other');
        });
      });
      _loadCaretakerData().then((value) {
        setState(() {
          caretakerList = value;
          selectedCaretakerId = caretakerList.first.id.toString();
        });
      });
    } else {
      _loadPatientData().then((value) {
        setState(() {
          patientList = value;

          selectedPatientId = patientList.first.id.toString();
        });
        for (var patientElement in patientList) {
          _loadData(patientElement.id.toString()).then((value) {
            setState(() {
              individualCareTaskslistMap
                  .addAll({patientElement.id.toString(): value});
            });
          });
        }
      });
    }
    filterEventLogs(selectedDay.value);
  }

  void filterEventLogs(DateTime dateParam) {
    var justDate = DateUtils.dateOnly(dateParam);
    setState(() {
      _filteredEventLogs = widget.eventLogs.where((eventLog) {
        return DateUtils.dateOnly(yMHTAStringToDateTime(eventLog.date)) ==
            justDate;
      }).toList();
    });
  }

  Future<List<Caretaker>> _loadCaretakerData() async {
    // Load the data asynchronously
    final data = await loadCaretakersFromFirestore();

    // Return the loaded data
    return data;
  }

  Future<List<Patient>> _loadPatientData() async {
    // Load the data asynchronously
    final data = await loadPatientsFromFirestore();

    // Return the loaded data
    return data;
  }

  Future<List<String>> _loadData(String patientId) async {
    // Load the data asynchronously
    final data = await getCareTaskNamesFromPatientId(patientId);

    // Return the loaded data
    return data;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _editKey = '';
          _focusNode.unfocus();
          FocusScope.of(context).unfocus();
        });
      },
      child: Scaffold(
        appBar: CustomAppBar(
          //todo make patient name dynamic
          title: widget.caller == Caller.patient
              ? 'Back to ${widget.patient!.name}\'s sheet'
              : 'Back to ${widget.caretaker!.name}\'s sheet',
          onBackPressed: () async {
            widget.caller == Caller.patient
                ? Navigator.of(context).pop(
                    MaterialPageRoute(
                        builder: (context) => PatientFormScreen(
                              patient: widget.patient!,
                              caretakerList: caretakerList,
                            )),
                  )
                : Navigator.of(context).pop(
                    MaterialPageRoute(
                        builder: (context) => CaretakerFormScreen(
                              caretaker: widget.caretaker!,
                            )),
                  );
          },
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: const AlignmentDirectional(-1.00, 0.00),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 15, 0, 0),
                child: Text(
                  widget.caller == Caller.patient
                      ? '${widget.patient!.name}\'s event log'
                      : '${widget.caretaker!.name}\'s event log',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
              child: ValueListenableBuilder<DateTime>(
                  valueListenable: selectedDay,
                  builder: (context, value, child) {
                    return TableCalendar(
                      firstDay: DateTime.utc(2020, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: focusedDay.value,
                      onFormatChanged: (format) {
                        if (calendarFormat != format) {
                          setState(() {
                            calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        this.focusedDay.value = focusedDay;
                      },
                      calendarFormat: calendarFormat,
                      selectedDayPredicate: (day) {
                        // Use `selectedDayPredicate` to determine which day is currently selected.
                        // If this returns true, then `day` is currently selected.
                        return isSameDay(value, day);
                      },
                      onDaySelected: (pSelectedDay, pFocusedDay) {
                        // Handle your date selection logic here.
                        // `selectedDay` is the day that was just selected.
                        // `focusedDay` is the day that is currently focused (i.e. the day that the calendar is centered around).
                        // If you update the `selectedDay` variable here, the calendar will automatically update to reflect the new selected day.
                        setState(() {
                          selectedDay.value = pSelectedDay;
                          focusedDay.value = pFocusedDay;
                          filterEventLogs(selectedDay.value);
                        });
                      },
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(0),
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.00, 0.00),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                    child: FlutterFlowIconButton(
                      borderRadius: 20,
                      borderWidth: 1,
                      buttonSize: 40,
                      icon: FaIcon(
                        FontAwesomeIcons.angleLeft,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24,
                      ),
                      onPressed: () {
                        selectedDay.value =
                            selectedDay.value.subtract(const Duration(days: 1));
                        focusedDay.value = selectedDay.value;
                        filterEventLogs(selectedDay.value);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 5),
                    child: Text(
                      'Navigate Days',
                      style: FlutterFlowTheme.of(context).bodyMedium,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                    child: FlutterFlowIconButton(
                      borderRadius: 20,
                      borderWidth: 1,
                      buttonSize: 40,
                      icon: FaIcon(
                        FontAwesomeIcons.angleRight,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24,
                      ),
                      onPressed: () {
                        selectedDay.value =
                            selectedDay.value.add(const Duration(days: 1));
                        focusedDay.value = selectedDay.value;
                        filterEventLogs(selectedDay.value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
                child: ListView.builder(
                    itemCount: _filteredEventLogs.length,
                    itemBuilder: (context, i) {
                      return Dismissible(
                        key: ValueKey<int>(_filteredEventLogs[i].id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 0,
                                  color: Color(0xFFE0E3E7),
                                  offset: Offset(0, 1),
                                )
                              ],
                              borderRadius: BorderRadius.circular(0),
                              shape: BoxShape.rectangle,
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 8, 8, 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 4,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12, 0, 0, 0),
                                      child: Text(
                                        _filteredEventLogs[i].name,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 15, 0),
                                    child: Text(
                                      DateFormat.yMMMd().format(
                                          yMHTAStringToDateTime(
                                              _filteredEventLogs[i].date)),
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium,
                                    ),
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      Patient patient =
                                          widget.caller == Caller.caretaker
                                              ? patientList
                                                  .where((element) =>
                                                      element.id.toString() ==
                                                      _filteredEventLogs[i]
                                                          .patientId)
                                                  .first
                                              : widget.patient!;
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EventLogFormScreen(
                                                    eventLog:
                                                        _filteredEventLogs[i],
                                                    caller: widget.caller,
                                                    modifying: true,
                                                    careTaskList: list,
                                                    individualCareTaskslistMap:
                                                        individualCareTaskslistMap,
                                                    patientList: patientList,
                                                    caretakerList:
                                                        caretakerList,
                                                    patient: patient,
                                                    caretaker:
                                                        widget.caretaker)),
                                      );
                                    },
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(4, 4, 4, 4),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            Patient patient = widget.caller ==
                                                    Caller.caretaker
                                                ? patientList
                                                    .where((element) =>
                                                        element.id.toString() ==
                                                        _filteredEventLogs[i]
                                                            .patientId)
                                                    .first
                                                : widget.patient!;
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EventLogFormScreen(
                                                          eventLog:
                                                              _filteredEventLogs[
                                                                  i],
                                                          caller: widget.caller,
                                                          modifying: true,
                                                          careTaskList: list,
                                                          individualCareTaskslistMap:
                                                              individualCareTaskslistMap,
                                                          patientList:
                                                              patientList,
                                                          caretakerList:
                                                              caretakerList,
                                                          patient: patient,
                                                          caretaker: widget
                                                              .caretaker)),
                                            );
                                          },
                                          child: Icon(
                                            Icons.keyboard_arrow_right_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            deleteEventLogFromFireStore(_filteredEventLogs[i]);
                            _filteredEventLogs.removeAt(i);
                          });
                        },
                      );
                    }),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: null,
          onPressed: () {
            widget.caller == Caller.patient
                ? Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EventLogFormScreen(
                        eventLog: EventLog.empty(widget.eventLogs.length + 1),
                        caller: Caller.patient,
                        modifying: false,
                        careTaskList: list,
                        individualCareTaskslistMap: individualCareTaskslistMap,
                        patientList: patientList,
                        caretakerList: caretakerList,
                        patient: widget.patient,
                        caretaker: widget.caretaker)))
                : Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EventLogFormScreen(
                        eventLog: EventLog(
                            id: widget.eventLogs.length + 1,
                            name: '',
                            description: '',
                            date: DateFormat('yyyy-MM-dd h:mm a')
                                .format(DateTime.now()),
                            patientId: selectedPatientId,
                            caretakerId: widget.caretaker!.id.toString()),
                        caller: Caller.caretaker,
                        modifying: false,
                        careTaskList: list,
                        individualCareTaskslistMap: individualCareTaskslistMap,
                        patientList: patientList,
                        caretakerList: caretakerList,
                        patient: patientList
                            .where((element) =>
                                element.id.toString() == selectedPatientId)
                            .first,
                        caretaker: widget.caretaker)));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _selectDate(
      BuildContext context, StateSetter setState, int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      // ignore: use_build_context_synchronously
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
          widget.eventLogs[index].date =
              DateFormat('yyyy-MM-dd h:mm a').format(_selectedDate);
        }
      }
    }
  }

  void saveToDb(EventLog eventLog) async {
    //modifyEventLogInDb(eventLog);
    getDocumentID(eventLog.id, 'patientTasks').then((docID) {
      updateEventLog(eventLog, docID);
    });
  }

  void stateSetter(
      {String? selectedPatientId, Map<String, List<String>>? newMap}) {
    setState(() {
      if (selectedPatientId != null) {
        this.selectedPatientId = selectedPatientId;
      }
      if (newMap != null) {
        individualCareTaskslistMap = newMap;
      }
    });
  }

  void setIndex(int index) {
    _editKey = index.toString();
  }

  void setFormTexts() {
    _descriptionController.text =
        widget.eventLogs[int.parse(_editKey)].description;
  }

  List<DropdownMenuEntry<String>> getTaskNameDropdownEntries({String? index}) {
    return widget.caller == Caller.patient
        ? list.map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(value: value, label: value);
          }).toList()
        : individualCareTaskslistMap[index]!
            .map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(value: value, label: value);
          }).toList();
  }

  List<DropdownMenuEntry<String>> getPersonTypeDropdownEntries() {
    return widget.caller == Caller.patient
        ? caretakerList.map<DropdownMenuEntry<String>>((Caretaker value) {
            return DropdownMenuEntry<String>(
                value: value.id.toString(), label: value.name);
          }).toList()
        : patientList.map<DropdownMenuEntry<String>>((Patient value) {
            return DropdownMenuEntry<String>(
                value: value.id.toString(), label: value.name);
          }).toList();
  }
}
