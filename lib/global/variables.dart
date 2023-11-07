import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

final db = FirebaseFirestore.instance;
int androidSdkVersion = 0;
String appName = "Caretaker App";
String selectedDateTime = DateTime.now().toString();
//DateTime monthlyPickerSelectedDate = DateTime.now();
String selectedDateTimeWhenAdding = "Select";
Color appForegroundColor = Colors.white;
Color appBackgroundColor = Colors.indigo.shade200;
Map<int, bool> checkboxState = {};

const Color kTextColor = Color(0xFF4879C5);
const InputDecoration kTextInputDecoration = InputDecoration(
  border: InputBorder.none,
  hintText: '',
  // ),
);
final auth = FirebaseAuth.instance;
