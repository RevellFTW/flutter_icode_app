import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/helper/firebase_helper.dart';
import 'package:todoapp/models/caretaker.dart';
import 'package:todoapp/screens/home_page.dart';
import '../models/relative.dart';
import '../models/user.dart';

final db = FirebaseFirestore.instance;
Relative? relative;
Caller loggedInUserType = Caller.backOfficePatient;
int androidSdkVersion = 0;
String appName = "Caretaker App";
String selectedDateTime = DateTime.now().toString();
//DateTime monthlyPickerSelectedDate = DateTime.now();
String selectedDateTimeWhenAdding = "Select";
Color appForegroundColor = Colors.white;
Color appBackgroundColor = const Color(0xff008080);
Map<int, bool> checkboxState = {};
bool firstLogin = true;
const Color kTextColor = Color(0xff008080);
const InputDecoration kTextInputDecoration = InputDecoration(
  border: InputBorder.none,
  hintText: '',
  // ),
);
final auth = FirebaseAuth.instance;
List<Caretaker> caretakerList = [];

Future<List<Caretaker>> loadCaretakers() async {
  final data = await loadCaretakersFromFirestore();

  return data;
}
