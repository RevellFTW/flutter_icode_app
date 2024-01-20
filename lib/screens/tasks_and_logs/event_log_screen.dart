import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todoapp/firebase_options.dart';
import 'package:todoapp/global/variables.dart';
import 'package:todoapp/helper/datetime_helper.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_icon_button.dart';
import 'package:todoapp/helper/flutter_flow/flutter_flow_theme.dart';
import 'package:todoapp/models/caretaker.dart';
import 'package:todoapp/screens/forms/caretaker_form_screen.dart';
import 'package:todoapp/screens/forms/event_log_form_screen.dart';
import 'package:todoapp/screens/forms/patient_form_screen.dart';
import 'package:todoapp/screens/settings.dart';
import 'package:todoapp/widget/custom_app_bar.dart';
import '../../helper/firestore_helper.dart';
import '../../models/event_log.dart';
import '../../models/patient.dart';
import '../home_page.dart';

class EventLogScreen extends StatefulWidget implements PreferredSizeWidget {
  final List<EventLog> eventLogs;

  final String eventLogName;
  final Caller caller;
  final Patient? patient;
  final Caretaker? caretaker;
  final bool isRelative;
  const EventLogScreen(
      {super.key,
      required this.eventLogs,
      required this.eventLogName,
      required this.caller,
      required this.isRelative,
      this.patient,
      this.caretaker});

  static const id = 'event_log_screen';

  @override
  // ignore: library_private_types_in_public_api
  _EventLogScreenState createState() => _EventLogScreenState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _EventLogScreenState extends State<EventLogScreen> {
  List<EventLog> _filteredEventLogs = [];
  final TextEditingController _descriptionController = TextEditingController();
  String currentTextFormFieldValue = '';

  DateTime _selectedDate = DateTime.now();

  late Caretaker selectedCaretaker;
  late Patient selectedPatient;

  ValueNotifier<DateTime> selectedDay = ValueNotifier<DateTime>(DateTime.now());
  ValueNotifier<DateTime> focusedDay = ValueNotifier<DateTime>(DateTime.now());

  CalendarFormat calendarFormat = CalendarFormat.week;

  final FocusNode _focusNode = FocusNode();
  late List<String> list = [];
  //late List<String> individualCareTaskslist = [];
  late Map<String, List<String>> individualCareTaskslistMap = {};
  late List<Caretaker> caretakerList = [];
  late List<Patient> patientList = [];

//editable/visible, to show/hide items if logged in as patient or else
  bool visible = true;

  String titleName = '';
  @override
  void initState() {
    super.initState();
    requestPermission();
    if (widget.caller == Caller.patient) visible = false;
    if (widget.caller == Caller.backOfficePatient ||
        widget.caller == Caller.patient) {
      titleName = widget.patient!.name;
      _loadData(widget.patient!.id.toString()).then((value) {
        list = value;
        list.add('Other');
      });
      _loadCaretakerData().then((value) {
        setState(() {
          caretakerList = value;
          selectedCaretaker = caretakerList.first;
        });
      });
    } else {
      titleName = widget.caretaker!.name;
      _loadPatientData().then((value) {
        setState(() {
          patientList = value;

          selectedPatient = patientList.first;
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
    return Scaffold(
      appBar: CustomAppBar(
        //todo make patient name dynamic
        title: 'Back to $titleName\'s sheet',
        visibility: visible,
        onBackPressed: () async {
          widget.caller == Caller.backOfficePatient
              ? Navigator.of(context).pop(
                  MaterialPageRoute(
                      builder: (context) => PatientFormScreen(
                            patient: widget.patient!,
                            caretakerList: caretakerList,
                            visibility: visible,
                            isRelative: widget.isRelative,
                          )),
                )
              : Navigator.of(context).pop(
                  MaterialPageRoute(
                      builder: (context) => CaretakerFormScreen(
                            caretaker: widget.caretaker!,
                          )),
                );
        },
        caller: widget.caller,
        patient: widget.patient,
        caretakers: caretakerList,
        isRelative: widget.isRelative,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Align(
            alignment: const AlignmentDirectional(-1.00, 0.00),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 15, 0, 0),
              child: Text(
                widget.eventLogName,
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
            padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
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
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
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
            alignment: const AlignmentDirectional(0.00, 0.00),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
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
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 5),
                  child: Text(
                    'Navigate Days',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
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
                    return Slidable(
                      endActionPane: visible
                          ? ActionPane(
                              motion: const ScrollMotion(),
                              children: <Widget>[
                                SlidableAction(
                                  onPressed: (context) => {
                                    setState(() {
                                      deleteEventLogFromFireStore(
                                          _filteredEventLogs[i]);
                                      _filteredEventLogs.removeAt(i);
                                    })
                                  },
                                  backgroundColor: Colors.red,
                                  icon: Icons.delete,
                                ),
                              ],
                            )
                          : null,
                      key: ValueKey<int>(_filteredEventLogs[i].id),
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
                                ),
                              ],
                              borderRadius: BorderRadius.circular(0),
                              shape: BoxShape.rectangle,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8, 8, 8, 8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 4,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(12, 0, 0, 0),
                                          child: Text(
                                            _filteredEventLogs[i].name == ''
                                                ? 'Other'
                                                : _filteredEventLogs[i].name,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12, 0, 15, 0),
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
                                          Patient patient = widget.caller ==
                                                  Caller.backOfficeCaretaker
                                              ? patientList
                                                  .where((element) =>
                                                      element.id ==
                                                      _filteredEventLogs[i]
                                                          .patient
                                                          .id)
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
                                                        visible: visible,
                                                        individualCareTaskslistMap:
                                                            individualCareTaskslistMap,
                                                        patientList:
                                                            patientList,
                                                        caretakerList:
                                                            caretakerList,
                                                        patient: patient,
                                                        isRelative:
                                                            widget.isRelative,
                                                        caretaker:
                                                            widget.caretaker)),
                                          );
                                        },
                                        child: Card(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(4, 4, 4, 4),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                Patient patient = widget
                                                            .caller ==
                                                        Caller
                                                            .backOfficeCaretaker
                                                    ? patientList
                                                        .where((element) =>
                                                            element.id ==
                                                            _filteredEventLogs[
                                                                    i]
                                                                .patient
                                                                .id)
                                                        .first
                                                    : widget.patient!;
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EventLogFormScreen(
                                                              eventLog:
                                                                  _filteredEventLogs[
                                                                      i],
                                                              caller:
                                                                  widget.caller,
                                                              modifying: true,
                                                              careTaskList:
                                                                  list,
                                                              visible: visible,
                                                              individualCareTaskslistMap:
                                                                  individualCareTaskslistMap,
                                                              patientList:
                                                                  patientList,
                                                              caretakerList:
                                                                  caretakerList,
                                                              patient: patient,
                                                              isRelative: widget
                                                                  .isRelative,
                                                              caretaker: widget
                                                                  .caretaker)),
                                                );
                                              },
                                              child: Icon(
                                                Icons
                                                    .keyboard_arrow_right_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
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
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12, 0, 0, 8),
                                        child: Text(
                                          widget.caller ==
                                                  Caller.backOfficePatient
                                              ? 'Assigned to ${_filteredEventLogs[i].caretaker.name}'
                                              : 'Assigned to ${_filteredEventLogs[i].patient.name}',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily: 'Readex Pro',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
      floatingActionButton: visible
          ? FloatingActionButton(
              heroTag: null,
              onPressed: () async {
                int eventLogLength = await getEventLogCountFromFirestore();
                widget.caller == Caller.backOfficePatient
                    ? Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EventLogFormScreen(
                            eventLog: EventLog.empty(
                                eventLogLength,
                                widget.caretaker ??
                                    Caretaker.empty(caretakerList.length + 1),
                                widget.patient ??
                                    Patient.empty(patientList.length + 1)),
                            caller: Caller.backOfficePatient,
                            modifying: false,
                            careTaskList: list,
                            visible: visible,
                            individualCareTaskslistMap:
                                individualCareTaskslistMap,
                            patientList: patientList,
                            caretakerList: caretakerList,
                            patient: widget.patient,
                            isRelative: widget.isRelative,
                            caretaker: selectedCaretaker)))
                    : Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EventLogFormScreen(
                            eventLog: EventLog(
                                id: eventLogLength,
                                name: '',
                                description: '',
                                date: DateFormat('yyyy-MM-dd h:mm a')
                                    .format(DateTime.now()),
                                patient: selectedPatient,
                                caretaker: widget.caretaker!),
                            caller: Caller.backOfficeCaretaker,
                            modifying: false,
                            careTaskList: list,
                            visible: visible,
                            individualCareTaskslistMap:
                                individualCareTaskslistMap,
                            patientList: patientList,
                            caretakerList: caretakerList,
                            patient: selectedPatient,
                            isRelative: widget.isRelative,
                            caretaker: widget.caretaker)));
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void saveToDb(EventLog eventLog) async {
    //modifyEventLogInDb(eventLog);
    getDocumentID(eventLog.id, 'patientTasks').then((docID) {
      updateEventLog(eventLog, docID);
    });
  }

  void stateSetter(
      {Patient? selectedPatient, Map<String, List<String>>? newMap}) {
    setState(() {
      if (selectedPatient != null) {
        this.selectedPatient = selectedPatient;
      }
      if (newMap != null) {
        individualCareTaskslistMap = newMap;
      }
    });
  }

  List<DropdownMenuEntry<String>> getTaskNameDropdownEntries({String? index}) {
    return widget.caller == Caller.backOfficePatient
        ? list.map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(value: value, label: value);
          }).toList()
        : individualCareTaskslistMap[index]!
            .map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(value: value, label: value);
          }).toList();
  }

  List<DropdownMenuEntry<String>> getPersonTypeDropdownEntries() {
    return widget.caller == Caller.backOfficePatient
        ? caretakerList.map<DropdownMenuEntry<String>>((Caretaker value) {
            return DropdownMenuEntry<String>(
                value: value.id.toString(), label: value.name);
          }).toList()
        : patientList.map<DropdownMenuEntry<String>>((Patient value) {
            return DropdownMenuEntry<String>(
                value: value.id.toString(), label: value.name);
          }).toList();
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    const vapidKey =
        "BAtT0PRD3_LdaR9i1eIt-MHS8IsHs97Ib_Uva8mS9uQshRAWk_1txhuRdNTa4eLqheq218J__iIjeWHsZAq0sE8";
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web) {
      await messaging.getToken(
        vapidKey: vapidKey,
      );
    } else {
      await messaging.getToken();
    }
  }
}
