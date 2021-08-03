import 'package:flutter/material.dart';
import 'package:flutter_app/customIcons/app_icons.dart';
import 'package:flutter_app/extentions/extentions.dart';
import 'package:flutter_app/views/auth/login.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/utils/PrefrenceUtil.dart';
import 'package:flutter_app/views/worker/home_page.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class LoginIntro extends StatefulWidget {
  LoginIntro({Key key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<LoginIntro> {
  bool status = false;
  List<bool> isSelected = [false, false];

  ImageProvider logo = AssetImage("assets/images/login_bg.jpg");
  @override
  void initState() {
    super.initState();
    getLocale();
    // PrefrenceUtil.getUser().then((value) {
    //   if (value != null) {
    //     Navigator.of(context).pushAndRemoveUntil(
    //         MaterialPageRoute(
    //             builder: (context) => WorkerHomePage(
    //                   title: "Home",
    //                 )),
    //         (Route<dynamic> route) => false);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Center(
        child: Stack(children: <Widget>[
          Positioned(
              child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  color: Colors.blue,
                ),
                child: Image(
                  fit: BoxFit.cover,
                  image: logo,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[200],
                  border: Border.all(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                margin: EdgeInsets.only(right: 20, top: 70),
                child: ToggleButtons(
                  fillColor: Colors.green[400],
                  selectedColor: Colors.white,
                  children: <Widget>[
                    Text("عربي"),
                    Text("עברי"),
                  ],
                  isSelected: isSelected,
                  onPressed: (int index) {
                    if (index == 0) {
                      context.setLocale(Locale("ar", ''));
                      PrefrenceUtil.setLanguage("ar");
                      isSelected[1] = false;
                      isSelected[0] = true;
                    } else {
                      context.setLocale(Locale("he", ''));
                      PrefrenceUtil.setLanguage("he");
                      isSelected[0] = false;
                      isSelected[1] = true;
                    }

                    setState(() {
                      isSelected = isSelected;
                    });
                  },
                ),
              ),
            ],
          )),
          Positioned(
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 280,
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
                            left: 30, right: 30, top: 40, bottom: 30),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        height: 40,
                        child: ElevatedButton(
                          child: Text(
                            "login_with_email".tr(),
                            style: TextStyle(fontFamily: "DroidKufiBold"),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  HexColor.fromHex("#388E3C")),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ))),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                        ),
                      ),
                      Text("login_with_social".tr(),
                          style: TextStyle(
                              fontSize: 12,
                              color: HexColor.fromHex("#94959C"),
                              fontFamily: "DroidKufiBold")),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 30, right: 10, top: 40, bottom: 15),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              height: 40,
                              child: ElevatedButton.icon(
                                label: Text(
                                  "google".tr(),
                                  style: TextStyle(fontFamily: "DroidKufiBold"),
                                ),
                                icon: Icon(AppIcons.gplus),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            HexColor.fromHex("#d32f2f")),
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
                          ),
                          Expanded(
                              child: Container(
                            margin: EdgeInsets.only(
                                left: 10, right: 30, top: 40, bottom: 15),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            height: 40,
                            child: ElevatedButton.icon(
                              label: Text(
                                "facebook".tr(),
                                style: TextStyle(fontFamily: "DroidKufiBold"),
                              ),
                              icon: Icon(AppIcons.facebook),
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
                                loginWithFacebook();
                              },
                            ),
                          )),
                        ],
                      )
                    ],
                  ),
                )),
          )
        ]),
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
      var temp = isSelected;

      setState(() {
        isSelected = temp;
      });
    });
  }

  void loginWithFacebook() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print(result.accessToken.token);
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        print(result.accessToken);
        break;
    }
  }
}
