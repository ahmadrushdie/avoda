import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/models/profile.dart';
import 'package:flutter_app/utils/PrefrenceUtil.dart';
import 'package:flutter_app/views/common/gallery_viewer.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/constants/apis_constants.dart';
import 'package:flutter_app/extentions/extentions.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/constants/fonts.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
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
  var bottomTabStyle = TextStyle(fontFamily: KOFI_BOLD, fontSize: 13);
  var pagerTabTextStyle = TextStyle(fontFamily: KOFI_REGULAR, fontSize: 15);
  Profile profile;
  @override
  void initState() {
    super.initState();
    getUserProfile();
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

    if (mounted) {
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    }
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

  getUserProfile() async {
    var user = await PrefrenceUtil.getUser();
    final response = await http.get(Uri.https(BASE_URL, USER_PORIFLE + user.id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": user.token
        });

    if (response.statusCode == 200) {
      var profile = Profile.fromJson(jsonDecode(response.body));
      if (mounted) {
        setState(() {
          this.profile = profile;
        });
      }
    }
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
        body: profile == null ? showLoading() : renderProfile(profile));
  }

  showLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  renderTags() {
    return Align(
        alignment: Alignment.topRight,
        child: Container(
            margin: EdgeInsets.only(top: 0, right: 0, bottom: 20),
            child: Column(children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    child: Text(
                      "languages".tr(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontFamily: KOFI_REGULAR, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Tags(
                    itemCount: profile.data.languages.length, // required
                    itemBuilder: (int index) {
                      final item = profile.data.languages[index];

                      return ItemTags(
                        // Each ItemTags must contain a Key. Keys allow Flutter to
                        // uniquely identify widgets.
                        key: Key(index.toString()),
                        index: index, // required
                        title: item == "Arabic" ? "عربي" : "عبري",
                        active: false,
                        pressEnabled: false,
                        elevation: 1,
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),

                        color: HexColor.fromHex("#ECF1FA"),
                        textStyle: TextStyle(
                          fontSize: 12,
                        ),
                        combine: ItemTagsCombine.withTextBefore,
                        // image: ItemTagsImage(
                        //     image: AssetImage(
                        //         "img.jpg") // OR NetworkImage("https://...image.png")
                        //     ), // OR null,
                        // icon: ItemTagsIcon(
                        //   icon: Icons.add,
                        // ), // OR null,
                      );
                    },
                  ),
                ],
              )
            ])));
  }

  renderProfile(Profile profile) {
    final List<Tab> myTabs = <Tab>[
      Tab(text: 'recommendations'.tr()),
      Tab(text: 'pics'.tr())
    ];

    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 70, right: 20),
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
          child: Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        margin: EdgeInsets.only(top: 0),
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: _image != null
                                    ? FileImage(_image)
                                    : AssetImage(
                                        'assets/images/login_bg.jpg')))),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                profile.data.fullName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  fontFamily: KOFI_REGULAR,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "عامل بناء",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: KOFI_REGULAR,
                                    color: Colors.white,
                                  ),
                                )),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: 200,
                                  margin: EdgeInsets.only(
                                      right: 0, top: 0, bottom: 30),
                                  child: ElevatedButton(
                                    child: Text("send_message".tr(),
                                        style: TextStyle(
                                            fontFamily: KOFI_REGULAR,
                                            fontWeight: FontWeight.normal)),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                HexColor.fromHex("#388E3C")),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ))),
                                    onPressed: () {},
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ]),
              profile.data.languages.length > 0 ? renderTags() : null
            ],
          ),
        ),
        Expanded(
            child: DefaultTabController(
          length: 2,
          initialIndex: 1,
          child: Scaffold(
            appBar: TabBar(
              labelStyle: pagerTabTextStyle,
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                      width: 2.0, color: Theme.of(context).primaryColor),
                  insets: EdgeInsets.symmetric(horizontal: 40.0)),
              tabs: myTabs,
              labelColor: Theme.of(context).primaryColor,
              indicatorColor: Theme.of(context).primaryColor,
            ),
            body: TabBarView(children: [
              renderRecommendation(profile),
              renderPhotoGrid(),
            ]),
          ),
        )),
      ],
    );
  }

  renderPhotoGrid() {
    var images = <String>[
      "https://images.unsplash.com/photo-1471879832106-c7ab9e0cee23?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHx8&w=1000&q=80",
      "https://placeimg.com/500/500/any",
      "https://placeimg.com/500/500/any",
      "https://placeimg.com/500/500/any",
      "https://placeimg.com/500/500/any",
      "https://placeimg.com/500/500/any",
      "https://placeimg.com/500/500/any",
      "https://placeimg.com/500/500/any"
    ];

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            itemCount: images.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 6.0, mainAxisSpacing: 6.0),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GalleryViewer(
                                images: images,
                              )),
                    );
                  },
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(images[index], fit: BoxFit.cover)));
            }));
  }

  renderRecommendation(Profile profile) {
    var list = profile.data.usersReference.refList;
    return Container(
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(list[index].from.fullName),
                      Text(list[index].text),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
