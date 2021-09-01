import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/constants/apis_constants.dart';
import 'package:flutter_app/extentions/extentions.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/views/auth/register.dart';
import 'package:flutter_app/constants/fonts.dart';
import 'package:flutter_app/views/common/toast.dart';
import 'package:flutter_app/views/employer/employer_home_page.dart';
import 'package:flutter_app/views/worker/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app/utils/PrefrenceUtil.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<Login> {
  String username = "", password = "";
  String usernameError, passwordError;

  @override
  void initState() {
    super.initState();
  }

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
                      margin: EdgeInsets.all(30),
                      child: TextFormField(
                        onChanged: (text) {
                          setState(() {
                            usernameError =
                                text.length > 0 ? null : "required_feild".tr();
                            username = text;
                          });
                        },
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          errorText: usernameError,
                          contentPadding: EdgeInsets.symmetric(vertical: -5),
                          labelText: 'email'.tr(),
                          labelStyle: TextStyle(
                            fontFamily: KOFI_REGULAR,
                            color: Theme.of(context).primaryColor,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6200EE)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30, right: 30),
                      child: TextFormField(
                        onChanged: (text) {
                          setState(() {
                            passwordError =
                                text.length > 0 ? null : "required_feild".tr();
                            password = text;
                          });
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          errorText: passwordError,
                          contentPadding: EdgeInsets.symmetric(vertical: -5),
                          labelText: "password".tr(),
                          labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontFamily: KOFI_REGULAR),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(
                          left: 50, right: 50, top: 40, bottom: 20),
                      child: ElevatedButton(
                        child: Text(
                          "login".tr(),
                          style: TextStyle(fontFamily: KOFI_BOLD),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).primaryColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                        onPressed: () {
                          handleLogin();
                        },
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 50, right: 50, bottom: 40),
                      child: ElevatedButton(
                        child: Text(
                          "new_account".tr(),
                          style: TextStyle(fontFamily: KOFI_BOLD),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                HexColor.fromHex("#388E3C")),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ))
        ]),
      )),
    );
  }

  loginUser(String username, String password) async {
    final response = await http.post(
      Uri.https(BASE_URL, LOGIN),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': username,
        'password': password,
      }),
    );
    Navigator.pop(context);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var user = User.fromJson(jsonDecode(response.body));
      PrefrenceUtil.saveUser(user);
      User.authToken = user.token;
      print(user.token);

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => WorkerHomePage(
      //             title: "Home",
      //           )),
      // );

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => getUserHomeScreen(user.userType)),
          (Route<dynamic> route) => false);
    } else {
      var data = jsonDecode(response.body);
      ToastUtil.showToast("login_error".tr());
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  getUserHomeScreen(String userType) {
    if (userType == "worker") {
      return WorkerHomePage(
        title: "Home",
      );
    } else if (userType == "employer") {
      return EmployerHomePage(
        title: "Home",
      );
    }
  }

  void handleLogin() {
    if (username.length > 0 && password.length > 0) {
      setState(() {
        usernameError = null;
        passwordError = null;
      });
      showLoaderDialog(context);
      loginUser(username, password);
    } else {
      setState(() {
        if (username.length == 0) {
          usernameError = "required_feild".tr();
        }

        if (password.length == 0) {
          passwordError = "required_feild".tr();
        }
      });
    }
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
