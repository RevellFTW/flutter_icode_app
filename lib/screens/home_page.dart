import 'package:flutter/material.dart';
import '../helper/persistent_bottom_bar_scaffold.dart';
import 'caretaker_screen.dart';
import 'patient_screen.dart';

class HomePage extends StatelessWidget {
  final _tab1navigatorKey = GlobalKey<NavigatorState>();
  final _tab2navigatorKey = GlobalKey<NavigatorState>();
  final Caller caller;
  static const String id = 'home_page';

  HomePage({super.key, required this.caller});

  @override
  Widget build(BuildContext context) {
    return caller == Caller.backOfficePatient
        ? PersistentBottomBarScaffold(
            items: [
              PersistentTabItem(
                tab: const PatientScreen(),
                icon: Icons.accessible,
                title: 'Patients',
                navigatorkey: _tab1navigatorKey,
              ),
              PersistentTabItem(
                tab: const CaretakerScreen(caller: Caller.backOfficeCaretaker),
                icon: Icons.account_circle_sharp,
                title: 'Caretakers',
                navigatorkey: _tab2navigatorKey,
              ),
            ],
          )
        : CaretakerScreen(
            caller: caller,
          );
  }
}

enum Caller { backOfficePatient, backOfficeCaretaker, patient, caretaker }
