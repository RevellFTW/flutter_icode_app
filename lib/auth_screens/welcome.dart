import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/components.dart';
import '../global/variables.dart';
import '../screens/home_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static String id = 'welcome_screen';

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
    }
    if (isBackOffice) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // Display your message here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You are not a back office user')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    checkUserType(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        backgroundColor: appBackgroundColor,
        foregroundColor: appForegroundColor,
      ),
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child: const Center(
          child: ScreenTitle(
            title:
                'Here we will redirect to Welcome Page if user is back-office user',
          ),
        ),
      ),
    );
  }
}
