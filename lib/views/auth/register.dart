import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/network/network_client.dart';
import 'package:flutter_app/constants/apis_constants.dart';
import 'package:flutter_app/views/common/loading_dialog.dart';
import 'package:flutter_app/views/common/toast.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<Register> {
  String fullName = "";
  String email = "";
  String password = "";
  String confirmPassword = "";
  String userTypeValue;
  String genderValue;
  DateTime selectedDate;
  final DateFormat formatter = DateFormat('M-dd-yyyy');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Center(
        child: Stack(children: <Widget>[
          Positioned(
              child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Colors.blue,
            ),
            child: Image(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/login_bg.jpg'),
            ),
          )),
          Positioned(
              child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 30),
                child: Wrap(children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: 30, right: 30, top: 30, bottom: 20),
                          child: TextFormField(
                            initialValue: fullName,
                            cursorColor: Theme.of(context).primaryColor,
                            onChanged: (text) {
                              setState(() {
                                fullName = text;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: -5),
                              labelText: 'full_name'.tr(),
                              labelStyle: TextStyle(
                                fontFamily: "DroidKufiRegular",
                                color: Theme.of(context).primaryColor,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF6200EE)),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 30, right: 30),
                          child: TextFormField(
                            initialValue: email,
                            onChanged: (text) {
                              setState(() {
                                email = text;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: -5),
                              labelText: "email".tr(),
                              labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontFamily: "DroidKufiRegular"),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 30, right: 30, top: 20, bottom: 20),
                          child: TextFormField(
                            obscureText: true,
                            initialValue: password,
                            onChanged: (text) {
                              setState(() {
                                password = text;
                              });
                            },
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: -5),
                              labelText: 'password'.tr(),
                              labelStyle: TextStyle(
                                fontFamily: "DroidKufiRegular",
                                color: Theme.of(context).primaryColor,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF6200EE)),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 30, right: 30),
                          child: TextFormField(
                            obscureText: true,
                            initialValue: confirmPassword,
                            onChanged: (text) {
                              setState(() {
                                confirmPassword = text;
                              });
                            },
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: -5),
                              labelText: 'confirm_password'.tr(),
                              labelStyle: TextStyle(
                                fontFamily: "DroidKufiRegular",
                                color: Theme.of(context).primaryColor,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF6200EE)),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                              margin:
                                  EdgeInsets.only(left: 30, right: 30, top: 20),
                              child: DropdownButton<String>(
                                value: userTypeValue,
                                hint: Text(
                                  "user_type".tr(),
                                  style: TextStyle(
                                      fontFamily: "DroidKufiRegular",
                                      fontSize: 16,
                                      color: Theme.of(context).primaryColor),
                                ),
                                iconSize: 0,
                                elevation: 16,
                                style: TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 1,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    userTypeValue = newValue;
                                  });
                                },
                                items: <String>[
                                  'worker'.tr(),
                                  'work_owner'.tr()
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "DroidKufiRegular")));
                                }).toList(),
                              )),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(left: 30, top: 20, right: 30),
                          child: RichText(
                              text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: selectedDate != null
                                      ? formatter.format(selectedDate)
                                      : 'select_birthday'.tr(),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      _selectDate(context);
                                    },
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontFamily: "DroidKufiRegular")),
                            ],
                          )),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(
                              left: 50, right: 50, top: 40, bottom: 20),
                          child: ElevatedButton(
                            child: Text(
                              "register".tr(),
                              style: TextStyle(fontFamily: "DroidKufiBold"),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context).primaryColor),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ))),
                            onPressed: () {
                              if (validateData()) {
                                registerUser();
                              } else {
                                ToastUtil.showToast("please_fill_data".tr());
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ])),
          ))
        ]),
      )),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime(2121),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  registerUser() async {
    DialogUtil.showLoadingDialog(context);

    String gvalue = "";
    // if (genderValue == 'male'.tr()) {
    //   gvalue = "male";
    // } else if (genderValue == 'female'.tr()) {
    //   gvalue = "female";
    // } else {
    //   gvalue = "other";
    // }

    String wvalue;
    if (userTypeValue == 'worker'.tr()) {
      wvalue = "worker";
    } else if (userTypeValue == 'work_owner'.tr()) {
      wvalue = "employer";
    }
    var params = {
      "fullName": fullName,
      "email": email,
      "password": password,
      "passwordConfirm": confirmPassword,
      "userType": wvalue,
      "birthday": formatter.format(selectedDate)
    };
    var response = await NetworkClient.getInstance().request(
        requestType: RequestType.POST, path: REGISTER_USER, parameter: params);
    Navigator.pop(context);
    if (response.statusCode == 200) {
      Navigator.pop(context);
      ToastUtil.showToast("register_success".tr());
    } else {
      var data = jsonDecode(response.body);
      ToastUtil.showToast(data["error"]);
    }
  }

  bool validateData() {
    if (password.length < 8) {
      ToastUtil.showToast("short_password".tr());
      return false;
    }
    return fullName.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        (password == confirmPassword) &&
        password.length >= 8 &&
        userTypeValue != null &&
        selectedDate != null;
  }
}
