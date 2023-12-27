import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todoapp/auth_screens/new_login_screen.dart';
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
  @override
  void initState() {
    super.initState();
    checkUserType(context);
  }

  Future<void> checkUserType(BuildContext context) async {
    bool isBackOffice = false;

    final user = auth.currentUser;
    if (user != null) {
      final userData = await db.collection('users').doc(user.uid).get();

      if (userData.exists) {
        final data = userData.data() as Map<String, dynamic>;
        if (data['approved'] == true && data['role'] == 'back-office') {
          isBackOffice = true;
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
    } else {
      // Display your message here
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are not a back office user')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    checkUserType(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(back_office ? appName : 'Under construction'),
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
          child: const Center(
              // child: ScreenTitle(
              //   //title: 'Page is under construction',
              // ),
              ),
        ),
      ),
    );
  }
}
