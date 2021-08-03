import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_app/models/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/views/employer/employer_home_page.dart';
import 'package:flutter_app/views/worker/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/login_intro.dart';

class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);

  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<Splash> {
  bool status = false;
  List<bool> isSelected = [false, false];

  @override
  void initState() {
    super.initState();
    checkUserType().then((value) => {
          Timer(
              Duration(seconds: 2),
              () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => getUserHomeScreen(value)),
                  (Route<dynamic> route) => false))
        });
  }

  getUserHomeScreen(String userType) {
    if (userType == null) {
      return LoginIntro();
    } else if (userType == "worker") {
      return WorkerHomePage(
        title: "home".tr(),
      );
    } else if (userType == "employer") {
      return EmployerHomePage(
        title: "home".tr(),
      );
    } else {
      return LoginIntro();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
                child: Image(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/logo.png'),
            )),
          ),
        ],
      ),
    );
  }

  Future<String> checkUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jsonString = prefs.getString("user");
    User user;
    if (jsonString != null) {
      user = User.fromJson(json.decode(jsonString));
      User.authToken = user.token;
    }
    return user != null ? user.userType : null;
  }
}
