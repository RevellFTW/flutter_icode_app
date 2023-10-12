import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../widget/app_theme.dart';
import '../providers/tasks_provider.dart';
import '../screens/tasks/add_task_screen.dart';
import '../screens/tasks/user_task_screen.dart';
import '../screens/splash_screen.dart';
import '../providers/auth.dart';
import '../screens/user_add_screen.dart';
import '../providers/user_provider.dart';
import '../screens/user_detail_screen.dart';
import '../screens/tabs_screen.dart';
import '../helper/scroll_behaviour.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';
import 'firebase_options.dart';

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
  final androidSdkVersion =
      deviceInfo is AndroidDeviceInfo ? deviceInfo.version.sdkInt : 0;
  runApp(MyApp(androidSdkVersion: androidSdkVersion));
}

final db = FirebaseFirestore.instance;

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.androidSdkVersion}) : super(key: key);
  final int androidSdkVersion;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: TasksProvider(),
        ),
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: UserProvider(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            scrollBehavior: CustomScrollBehavior(
              androidSdkVersion: widget.androidSdkVersion,
            ),
            theme: Provider.of<UserProvider>(context).isDark
                ? DarkTheme.darkThemeData
                : LightTheme.lightThemeData,
            home: auth.isAuth
                ? const Tabs()
                : FutureBuilder(
                    future: auth.tryLogin(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? Container(
                                color: Colors.white,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : const SplashScreen(),
                  ),
            routes: {
              AddTask.routeName: (ctx) => const AddTask(),
              UserTaskScreen.routeName: (ctx) => const UserTaskScreen(),
              UserAddScreen.routeName: (ctx) => const UserAddScreen(),
              UserDetailScreen.routeName: (ctx) => const UserDetailScreen(),
              Tabs.routeName: (ctx) => const Tabs(),
            },
          );
        },
      ),
    );
  }
}
