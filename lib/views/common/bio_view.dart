import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/constants/apis_constants.dart';
import 'package:flutter_app/constants/fonts.dart';
import 'package:flutter_app/utils/PrefrenceUtil.dart';
import 'package:http/http.dart' as http;

class BioPage extends StatefulWidget {
  BioPage({Key key, this.fullname, this.bio}) : super(key: key);

  String fullname, bio;
  @override
  _BioPageState createState() => _BioPageState();
}

class _BioPageState extends State<BioPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("personal_info".tr()),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: widget.fullname,
                onChanged: (text) {
                  setState(() {
                    widget.fullname = text;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'full_name'.tr(),
                  border: OutlineInputBorder(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 35),
                child: TextFormField(
                  initialValue: widget.bio,
                  onChanged: (text) {
                    setState(() {
                      widget.bio = text;
                    });
                  },
                  maxLines: null,
                  minLines: 5,
                  decoration: InputDecoration(
                    labelText: 'about'.tr(),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 40,
                margin:
                    EdgeInsets.only(left: 50, right: 50, top: 40, bottom: 20),
                child: ElevatedButton(
                  child: Text(
                    "save".tr(),
                    style: TextStyle(fontFamily: KOFI_BOLD),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                  onPressed: () {
                    updateBio(widget.fullname, widget.bio);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateBio(String fullname, String bio) async {
    showLoaderDialog(context);
    var user = await PrefrenceUtil.getUser();
    final response = await http.patch(
      Uri.https(BASE_URL, UPDATE_BIO),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": user.token
      },
      body: jsonEncode(<String, String>{
        'fullName': fullname,
        'bio': bio,
      }),
    );
    Navigator.pop(context);

    if (response.statusCode == 200) {
      Navigator.pop(context, "OK");
    } else if (response.statusCode == 401) {}
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7, right: 20),
              child: Text(
                "please_wait".tr(),
                style: TextStyle(fontFamily: KOFI_REGULAR),
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
