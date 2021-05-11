import 'package:flutter/material.dart';
import 'package:flutter_app/customIcons/app_icons.dart';
import 'package:flutter_app/extentions/extentions.dart';
import 'package:flutter_app/views/auth/login.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/utils/PrefrenceUtil.dart';
import 'package:flutter_app/views/worker/home_page.dart';

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
    getLocale();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Image(
        fit: BoxFit.cover,
        width: 100,
        height: 100,
        image: AssetImage('assets/images/login_bg.jpg'),
      )),
    );
  }

  getLocale() async {
    PrefrenceUtil.getLanguageLocale().then((value) {
      if (value.languageCode == "ar") {
        isSelected[1] = false;
        isSelected[0] = true;
      } else {
        isSelected[0] = false;
        isSelected[1] = true;
      }

      setState(() {
        isSelected = isSelected;
      });
    });
  }
}
