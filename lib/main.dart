import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';
import 'package:todoapp/auth_screens/new_login_screen.dart';
import 'package:todoapp/models/patient.dart';
import 'package:todoapp/screens/home_page.dart';
import 'package:todoapp/screens/patient_screen.dart';
import 'package:todoapp/screens/settings.dart';
import 'auth_screens/welcome.dart';
import 'firebase_options.dart';
import 'global/variables.dart';

final log = Logger('MainLogger');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    loadCaretakers().then((value) {
      caretakerList = value;
    });
  } catch (e) {
    log.severe('Could not initialize app: $e');
  }

  final deviceInfo = await DeviceInfoPlugin().deviceInfo;
  runApp(const MyApp());
}

//todo make user in firebase, and load this with auth and more properties

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    appName = 'Caretaker App';
    // if (currentUser.role == 'back-office') {
    appName = 'Back-Office Caretaker App';
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      //home: HomePage(),
      initialRoute: AuthWidget.id,
      routes: {
        AuthWidget.id: (context) => const AuthWidget(),
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        HomePage.id: (context) => HomePage()
      },
      onGenerateRoute: (settings) {
        if (settings.name == PatientScreen.id) {
          return MaterialPageRoute(
            builder: (context) => const PatientScreen(),
          );
        }

        return MaterialPageRoute(
          builder: (context) => const AuthWidget(),
        );
      },
    );
  }
}
