import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';
import 'firebase_options.dart';
import 'global/variables.dart';
import 'screens/home_page.dart';

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

//   DocumentReference documentReference = FirebaseFirestore.instance
//       .collection('patients')
//       .doc('XJLq6N47U33SN7ITYVOB');

//   // Add a new collection which has the caretask name, and the frequency
//   Map<String, Map<String, String>> careTasks = {};
//   careTasks['0'] = {
//     'task': 'Go for a wak',
//     'frequency': 'weekly',
//   };
//   careTasks['1'] = {
//     'task': 'Make breakfast',
//     'frequency': 'daily',
//   };
//   careTasks['2'] = {
//     'task': 'Do laundry',
//     'frequency': 'weekly',
//   };
// //print typeof caretask
//   print(careTasks.runtimeType);

//   // Update the document with the new data
//   await documentReference
//       .set({'careTasks': careTasks}, SetOptions(merge: true));

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
    if (currentUser.role == 'back-office') {
      appName = 'Back-Office Caretaker App';
      appForegroundColor = appForegroundColor;
      appBackgroundColor = appBackgroundColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: true,
      home: HomePage(),
    );
  }
}
