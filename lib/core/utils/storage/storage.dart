import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  Storage._();

  static final Storage instance = Storage._();

  late SharedPreferences pref;

  Future<void> initializeStorage() async {
    pref = await SharedPreferences.getInstance();
  }

  bool get isLogin => pref.getBool("isLoggedIn") ?? false;

  bool get showOnboarding => pref.getBool("showOnboarding") ?? true;

  String get role => pref.getString("role") ?? "";

  String get token => pref.getString("token") ?? "";

  Future<void> getStartOnboarding() async {
    await pref.setBool("showOnboarding", false);
  }

  Future<void> setUser(String tokenVal) async {
    debugPrint(tokenVal);
    await pref.setString("token", tokenVal);
    await pref.setBool("isLoggedIn", true);
  }

  Future<void> logout() async {
    await pref.setBool("isLoggedIn", false);
    await pref.remove(token);
  }
}
