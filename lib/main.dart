import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';
import 'auth_screens/home_screen.dart';
import 'auth_screens/login_screen.dart';
import 'auth_screens/signup_screen.dart';
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
    appForegroundColor = appForegroundColor;
    appBackgroundColor = appBackgroundColor;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: true,
      //home: HomePage(),
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => const HomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        SignUpScreen.id: (context) => const SignUpScreen(),
        WelcomeScreen.id: (context) => const WelcomeScreen(),
      },
    );
  }
}
