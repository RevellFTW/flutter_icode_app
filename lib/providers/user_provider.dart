import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark {
    return _isDark;
  }

  void fetchData() async {
    final prefs = await SharedPreferences.getInstance();

    final extractedData =
        jsonDecode(prefs.getString('userData')!) as Map<String, dynamic>;

    notifyListeners();
  }

  void setTheme(bool value) async {
    _isDark = value;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('theme', _isDark);
  }

  void fetchTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // try {
    //   _isDark = prefs.getBool('theme')!;
    // } catch (e) {
    //   rethrow;
    // } finally {
    //   _isDark = false;
    // }

    _isDark = prefs.getBool('theme') ?? false;

    notifyListeners();
  }

  void deleteThemeData() async {
    _isDark = false;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
