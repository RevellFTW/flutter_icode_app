import 'package:flutter/material.dart';
import '/widget/task_groups.dart';
import '/widget/task_builder.dart';

class UserTaskScreen extends StatelessWidget {
  static const routeName = '/user-task';
  const UserTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caretaker app'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TaskGroups(),
            SizedBox(
              height: 10,
            ),
            // TaskBuilder(filter: 'NoGroup'),
          ],
        ),
      ),
    );
  }

  Widget textDecoration(String text, BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      margin: const EdgeInsets.only(left: 10, bottom: 10),
      width: isLandscape
          ? mediaQuery.size.width * 0.2
          : mediaQuery.size.width * 0.4,
      height: isLandscape
          ? mediaQuery.size.width * 0.06
          : mediaQuery.size.height * 0.06,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: mediaQuery.textScaleFactor * 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
