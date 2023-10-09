import 'package:flutter/material.dart';
import '/widget/task_builder.dart';

class AllTask extends StatelessWidget {
  const AllTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tasks'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: TaskBuilder(
            filter: 'NoGroup',
          ),
        ),
      ),
    );
  }
}
