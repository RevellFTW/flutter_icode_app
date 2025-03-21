import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/models/relative.dart';
import 'package:todoapp/screens/home_page.dart';
import '../helper/flutter_flow/flutter_flow_icon_button.dart';
import '../helper/flutter_flow/flutter_flow_theme.dart';
import '../global/variables.dart';
import '../helper/firestore_helper.dart';
import '../models/caretaker.dart';
import 'forms/caretaker_form_screen.dart';
import 'settings.dart';

class CaretakerScreen extends StatefulWidget {
  const CaretakerScreen({super.key, required this.caller});
  final Caller caller;

  @override
  // ignore: library_private_types_in_public_api
  _CaretakerScreenState createState() => _CaretakerScreenState();
}

class _CaretakerScreenState extends State<CaretakerScreen> {
  final TextEditingController _caretakerNameController =
      TextEditingController();
  List<Caretaker> caretakers = [];
  final TextEditingController _searchController = TextEditingController();
  List<Caretaker> _filteredCaretakers = [];

  Caretaker? getCaretaker(int id) {
    return caretakers.firstWhere((caretaker) => caretaker.id == id);
  }

  @override
  void initState() {
    super.initState();

    _loadCaretakerData().then((value) {
      if (mounted) {
        setState(() {
          caretakers = value;
          _filteredCaretakers = caretakers;
        });
      }
    });

    _searchController.addListener(() {
      filterCaretakers();
    });
    filterCaretakers();
  }

  @override
  void dispose() {
    _caretakerNameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<List<Caretaker>> _loadCaretakerData() async {
    // Load the data asynchronously
    final data = await loadCaretakersFromFirestore();

    // Return the loaded data
    return data;
  }

  Future<List<Relative>> _loadRelativeData() async {
    // Load the data asynchronously
    final data = await loadRelativesFromFirestore();

    // Return the loaded data
    return data;
  }

  void filterCaretakers() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _filteredCaretakers = caretakers;
      });
    }
    String searchText = _searchController.text;
    setState(() {
      _filteredCaretakers = caretakers.where((caretaker) {
        return caretaker.name.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: appBackgroundColor,
          foregroundColor: appForegroundColor,
          automaticallyImplyLeading: false,
          actions: const [],
          flexibleSpace: FlexibleSpaceBar(
            title: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 14),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: Align(
                            alignment: const AlignmentDirectional(0.00, 0.00),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  4, 0, 0, 0),
                              child: Text(
                                'CuramusApp',
                                style: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .override(
                                      fontFamily: 'Outfit',
                                      color: Colors.white,
                                      fontSize: 22,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Curamus Back-Office',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                          ),
                          Flexible(
                            child: Align(
                              alignment: const AlignmentDirectional(1.00, 0.00),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    12, 0, 0, 0),
                                child: FlutterFlowIconButton(
                                  borderColor: Colors.transparent,
                                  borderRadius: 30,
                                  borderWidth: 1,
                                  buttonSize: 50,
                                  icon: const Icon(
                                    Icons.settings_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SettingsScreen(
                                                    widget.caller,
                                                    widget.caller ==
                                                            Caller.caretaker
                                                        ? 'Caretaker'
                                                        : 'Back-Office',
                                                    null,
                                                    [],
                                                    false)));
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            centerTitle: true,
            expandedTitleScale: 1.0,
          ),
          elevation: 2,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 0),
            child: TextFormField(
              controller: _searchController,
              onEditingComplete: filterCaretakers,
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'Search for caretakers...',
                labelStyle: FlutterFlowTheme.of(context).labelMedium,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).primaryBackground,
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
                filled: true,
                fillColor: FlutterFlowTheme.of(context).primaryBackground,
                prefixIcon: Icon(
                  Icons.search_outlined,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
              style: FlutterFlowTheme.of(context).bodyMedium,
              maxLines: null,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 0, 0),
                child: Text(
                  'Caretakers matching search',
                  style: FlutterFlowTheme.of(context).labelMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(4, 12, 16, 0),
                child: Text(
                  _filteredCaretakers.length.toString(),
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
              child: ListView.builder(
                  itemCount: _filteredCaretakers.length,
                  itemBuilder: (context, i) {
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: <Widget>[
                          SlidableAction(
                            onPressed: (context) => {
                              removeCaretaker(_filteredCaretakers[i].id),
                              setState(() {
                                filterCaretakers();
                              })
                            },
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                          ),
                        ],
                      ),
                      key: ValueKey<int>(_filteredCaretakers[i].id),
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
                                    color: FlutterFlowTheme.of(context).primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 0, 0),
                                    child: Text(
                                      _filteredCaretakers[i].name,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      12, 0, 15, 0),
                                  child: Text(
                                    DateFormat.yMMMd().format(
                                        _filteredCaretakers[i].startDate),
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
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CaretakerFormScreen(
                                          caretaker: _filteredCaretakers[i],
                                          modifying: true,
                                          caller: widget.caller,
                                        ),
                                      ),
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
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              4, 4, 4, 4),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CaretakerFormScreen(
                                                      caretaker:
                                                          _filteredCaretakers[
                                                              i],
                                                      modifying: true,
                                                      caller: widget.caller),
                                            ),
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
                    );
                  }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        backgroundColor: appBackgroundColor,
        foregroundColor: appForegroundColor,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CaretakerFormScreen(
                    caretaker: Caretaker.empty(caretakers.length + 1),
                    modifying: false,
                    caller: widget.caller,
                  )));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void addCaretaker(String string) {
    Caretaker caretaker = Caretaker(
        id: caretakers.length + 1,
        startDate: DateTime.now(),
        dateOfBirth: DateTime.now(),
        workTypes: '',
        availability: '',
        email: '',
        name: string,
        patients: []);
    caretakers.add(caretaker);
    addCaretakerToDb(caretaker);
  }

  void removeCaretaker(int id) {
    caretakers.removeWhere((caretaker) => caretaker.id == id);
    removeCaretakerFromDb(id);
  }
}
