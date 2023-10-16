import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CareTasksPage extends StatefulWidget {
  final List<String> careTasks;

  const CareTasksPage({super.key, required this.careTasks});

  @override
  _CareTasksPageState createState() => _CareTasksPageState();
}

class _CareTasksPageState extends State<CareTasksPage> {
  final TextEditingController _taskController = TextEditingController();
  int _editIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Care Tasks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.careTasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: _editIndex == index
                        ? TextField(
                            controller: _taskController,
                            onSubmitted: (newValue) {
                              setState(() {
                                widget.careTasks[index] = newValue;
                                _editIndex = -1;
                                _taskController.clear();
                              });
                            },
                          )
                        : Text(widget.careTasks[index]),
                    onTap: () {
                      setState(() {
                        if (_editIndex == -1) {
                          _editIndex = index;
                          _taskController.text = widget.careTasks[index];
                        } else {
                          _editIndex = -1;
                          _taskController.clear();
                        }
                      });
                    },
                    onLongPress: () {
                      setState(() {
                        widget.careTasks.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _taskController.clear();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Add New Care Task'),
                content: TextField(
                  controller: _taskController,
                  decoration: const InputDecoration(labelText: 'Care Task'),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Add'),
                    onPressed: () {
                      if (_taskController.text.isNotEmpty) {
                        setState(() {
                          widget.careTasks.add(_taskController.text);
                        });
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
