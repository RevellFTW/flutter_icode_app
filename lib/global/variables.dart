import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

final db = FirebaseFirestore.instance;
int androidSdkVersion = 0;
final currentUser = User(name: 'John Doe', role: 'back-office');
String appName = "Caretaker App";
String selectedDateTime = DateTime.now().toString();
String selectedDateTimeWhenAdding = "Select";
Color appForegroundColor = Colors.white;
Color appBackgroundColor = Colors.indigo.shade200;
Map<int, bool> checkboxState = {};
