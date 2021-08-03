import 'dart:convert';

import 'package:flutter_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class PrefrenceUtil {
  SharedPreferences prefs;

  PrefrenceUtil() {}
  static getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('lang').toString();
  }

  static Future<Locale> getLanguageLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var lang = prefs.getString('lang');
    return Locale(lang == null ? "ar" : lang, '');
  }

  static setLanguage(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lang', lang);
  }

  static void saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", json.encode(user));
  }

  static void deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("user");
  }

  static Future<User> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jsonString = prefs.getString("user");
    return jsonString != null ? User.fromJson(json.decode(jsonString)) : null;
  }
}
