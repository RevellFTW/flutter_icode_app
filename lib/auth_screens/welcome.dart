import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todoapp/auth_screens/new_login_screen.dart';
import 'package:todoapp/helper/firestore_helper.dart';
import 'package:todoapp/models/event_log.dart';
import 'package:todoapp/models/patient.dart';
import 'package:todoapp/screens/tasks_and_logs/event_log_screen.dart';
import '../global/variables.dart';
import '../screens/home_page.dart';

bool back_office = false;

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  static String id = 'welcome_screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool loading = true;
  bool back_office = false;

  @override
  void initState() {
    checkUserType(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      firstLogin = false;
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        //todo add one more if we implement caretakers
        title: Text(back_office ? appName : 'Event tasks'),
        backgroundColor: appBackgroundColor,
        foregroundColor: appForegroundColor,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30, top: 10),
        child: WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return false;
          },
          child: const Center(),
        ),
      ),
    );
  }

  void checkUserType(BuildContext context) async {
    relative = null;
    bool isBackOffice = false;
    bool isPatient = false;
    bool isRelative = false;
    final user = auth.currentUser;
    DocumentSnapshot<Map<String, dynamic>>? userData;
    Map<String, dynamic>? data;
    if (user != null) {
      userData = await db.collection('users').doc(user.uid).get();

      if (userData.exists) {
        data = userData.data() as Map<String, dynamic>;
        if (data['approved'] == true) {
          switch (data['role']) {
            case 'back-office':
              {
                isBackOffice = true;
                break;
              }
            case 'patient':
              {
                isPatient = true;
              }
            case 'relative':
              {
                isRelative = true;
              }
          }
        }
      } else {
        Navigator.pushNamed(context, AuthWidget.id);
      }
      if (isBackOffice) {
        back_office = true;
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
      if (isRelative) {
        relative = await getRelativeFromDb(data!['roleId'].toString());
      }
      if (isPatient || isRelative) {
        Patient patient = isRelative
            ? await getPatientFromDb(data!['patientId'].toString())
            : await getPatientFromDb(data!['roleId'].toString());
        List<EventLog> eventLogs =
            await loadEventLogsFromFirestore(patient.id, Caller.patient);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => EventLogScreen(
                    eventLogs: eventLogs,
                    patient: patient,
                    eventLogName: "${patient.name} Patient's Log ",
                    caller: Caller.patient,
                    isRelative: isRelative,
                  )),
        );
      }
      setState(() {
        loading = false;
      });
    }
  }

  Future<List<Patient>> _loadPatientData() async {
    // Load the data asynchronously
    final data = await loadPatientsFromFirestore();

    // Return the loaded data
    return data;
  }
}
