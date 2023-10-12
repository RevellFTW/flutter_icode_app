import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/spreadsheet.dart';
import '../providers/user_provider.dart';

class Tabs extends StatefulWidget {
  static const routeName = '/tabs-page';
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
  int currentIndex = 0;

  final List tabs = [
    PatientTable(patients: patients),
    PatientTable(patients: patients),
  ];

  late AnimationController _animationController;

  bool isInit = false;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..addListener(() {
        setState(() {});
      });

    isInit = true;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      getThemeData();
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final darkTheme = Provider.of<UserProvider>(context).isDark;
    return Scaffold(
      body: tabs[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: color,
        selectedItemColor: Colors.white,
        unselectedItemColor:
            darkTheme ? const Color.fromARGB(255, 0, 0, 0) : null,
        iconSize: isLandscape
            ? MediaQuery.sizeOf(context).height * 0.07
            : MediaQuery.sizeOf(context).width * 0.07,
        items: [
          BottomNavigationBarItem(
            label: 'Patients',
            icon: const Icon(
              Icons.home,
            ),
            backgroundColor: color,
          ),
          BottomNavigationBarItem(
            label: 'Caretakers',
            icon: const Icon(
              Icons.task,
            ),
            backgroundColor: color,
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  void getThemeData() {
    Provider.of<UserProvider>(context).fetchTheme();
  }
}
