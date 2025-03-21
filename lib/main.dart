import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';
import 'package:todoapp/auth_screens/new_login_screen.dart';
import 'package:todoapp/screens/home_page.dart';
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

  // final settings = await FirebaseMessaging.instance.requestPermission();
//  final token = await FirebaseMessaging.instance.getToken();
  runApp(const MyApp());
}

String applicationToken = '';

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
        HomePage.id: (context) => HomePage(caller: Caller.backOfficePatient),
      },
    );
  }
}
