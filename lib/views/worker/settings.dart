import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/constants/fonts.dart';

class SettingPage extends StatefulWidget {
  SettingPage({this.images}) : super();

  List<String> images;
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _platformVersion = 'Unknown';
  var textStyle = TextStyle(fontFamily: KOFI_REGULAR, fontSize: 15);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("settings".tr(), style: textStyle),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.amber),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text("تخصصات العمل", style: TextStyle(backgroundColor: Colors.blue)),
          Text("تخصصات العمل", style: TextStyle(backgroundColor: Colors.blue)),
        ]),
      ),
    );
  }
}
