import 'package:flutter/material.dart';
import '../helper/persistent_bottom_bar_scaffold.dart';
import 'tasks/caretaker_screen.dart';
import 'tasks/patient_screen.dart';

class HomePage extends StatelessWidget {
  final _tab1navigatorKey = GlobalKey<NavigatorState>();
  final _tab2navigatorKey = GlobalKey<NavigatorState>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentBottomBarScaffold(
      items: [
        PersistentTabItem(
          tab: const PatientScreen(),
          icon: Icons.accessible,
          title: 'Patients',
          navigatorkey: _tab1navigatorKey,
        ),
        PersistentTabItem(
          tab: const CaretakerScreen(),
          icon: Icons.account_circle_sharp,
          title: 'Caretakers',
          navigatorkey: _tab2navigatorKey,
        ),
      ],
    );
  }
}
