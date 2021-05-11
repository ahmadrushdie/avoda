import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/extentions/extentions.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<Register> {
  String userTypeValue;
  String genderValue;
  DateTime selectedDate;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
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
                            cursorColor: Theme.of(context).primaryColor,
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
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                              margin: EdgeInsets.only(
                                left: 30,
                                top: 20,
                                right: 30,
                              ),
                              child: DropdownButton<String>(
                                value: genderValue,
                                hint: Text(
                                  "gender".tr(),
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
                                    genderValue = newValue;
                                  });
                                },
                                items: <String>[
                                  'male'.tr(),
                                  'female'.tr(),
                                  'other'.tr()
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style: TextStyle(
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
                              print('Pressed');
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
}
