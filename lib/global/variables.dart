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

void navigateTo(BuildContext context, Widget page, {bool reverse = false}) {
  var curve = reverse ? Curves.easeIn : Curves.easeOut;
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
}
