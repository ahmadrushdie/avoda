import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/extentions/extentions.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/utils/fonts.dart' as Constants;
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  String title;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedIndex = 0;
  File _image;
  final picker = ImagePicker();
  var bottomTabStyle = TextStyle(fontFamily: Constants.KOFI_BOLD, fontSize: 13);

  @override
  void initState() {
    super.initState();
    print(User.authToken);
  }

  Future _imgFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future _imgFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: 320,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, stops: [
          0.1,
          0.5,
          0.9
        ], colors: [
          Theme.of(context).primaryColor.withOpacity(.7),
          Theme.of(context).primaryColor.withOpacity(.5),
          Theme.of(context).primaryColor..withOpacity(.9)
        ])),
        child: Column(children: [
          Container(
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 40,
                    height: 30,
                    margin: EdgeInsets.only(left: 0),
                    child: IconButton(
                        icon: const Icon(
                          Icons.photo_camera,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _showPicker(context);
                        }),
                  )),
              margin: EdgeInsets.only(top: 60),
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/login_bg.jpg')))),
          Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                "أحمد ناصر",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: Constants.KOFI_REGULAR,
                  color: Colors.white,
                ),
              )),
          Text(
            "عامل بناء",
            style: TextStyle(
              fontSize: 13,
              fontFamily: Constants.KOFI_REGULAR,
              color: Colors.white,
            ),
          ),
          Container(
            width: 200,
            margin: EdgeInsets.only(left: 50, right: 50, top: 0, bottom: 0),
            child: ElevatedButton(
              child: Text("send_message".tr(),
                  style: TextStyle(
                      fontFamily: Constants.KOFI_REGULAR,
                      fontWeight: FontWeight.normal)),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      HexColor.fromHex("#388E3C")),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              onPressed: () {},
            ),
          ),
        ]),
      ),
    );
  }
}
