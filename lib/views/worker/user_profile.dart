import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/models/profile.dart';
import 'package:flutter_app/utils/PrefrenceUtil.dart';
import 'package:flutter_app/views/common/bio_view.dart';
import 'package:flutter_app/views/common/gallery_viewer.dart';
import 'package:flutter_app/views/common/rounded_image.dart';
import 'package:flutter_app/views/common/toast.dart';
import 'package:flutter_app/views/worker/settings.dart';
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
  var bioHeaderStyle =
      TextStyle(fontFamily: KOFI_REGULAR, fontSize: 12, color: Colors.grey);
  var deleteAlbumPhotoStyle =
      TextStyle(fontFamily: KOFI_REGULAR, fontSize: 14, color: Colors.white);
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
                      title: new Text(
                        "photo_library".tr(),
                        style: pagerTabTextStyle,
                      ),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text(
                      "camera".tr(),
                      style: pagerTabTextStyle,
                    ),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.delete),
                    title: new Text(
                      "delete_photo".tr(),
                      style: pagerTabTextStyle,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      deleteUserProfilePic();
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

  deleteUserProfilePic() async {
    showLoaderDialog(context);
    var user = await PrefrenceUtil.getUser();
    final response = await http.delete(Uri.https(BASE_URL, DELETE_PROFILE_PIC),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": user.token
        });

    if (response.statusCode == 200) {
      Navigator.pop(context);
    }
  }

  deleteGridPic(int position) async {
    showLoaderDialog(context);
    var user = await PrefrenceUtil.getUser();
    final response = await http.delete(
        Uri.https(
            BASE_URL,
            DELETE_GRID_PIC +
                profile.data.profilePhotos.photosList[position].sId),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": user.token
        });

    if (response.statusCode == 200) {
      var tempProf = profile;
      tempProf.data.profilePhotos.photosList.removeAt(position);
      setState(() {
        profile = tempProf;
      });
      Navigator.pop(context);
      ToastUtil.showToast("photo_deleted_success".tr());
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
    final List<Widget> myTabs = <Widget>[
      Tab(text: 'personal_info'.tr()),
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
                    Stack(
                      children: [
                        CustomNetworkImage(
                          imageUrl: profile.data.userPic,
                          width: 100,
                          isCircular: true,
                          hieght: 100,
                        ),
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
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                profile.data.fullName != null
                                    ? profile.data.fullName
                                    : "",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  fontFamily: KOFI_REGULAR,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            if (profile.data.workFields != null &&
                                profile.data.workFields.length > 0)
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
                                    child: Text("logout".tr(),
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
                    Container(
                        margin: EdgeInsets.only(top: 3),
                        child: IconButton(
                            icon: Icon(Icons.settings, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingPage()),
                              );
                            }))
                  ]),
              if (profile.data.languages.length > 0) renderTags()
            ],
          ),
        ),
        Expanded(
            child: DefaultTabController(
          length: 3,
          initialIndex: 2,
          child: Scaffold(
            appBar: TabBar(
              labelStyle: pagerTabTextStyle,
              isScrollable: true,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                    width: 2.0, color: Theme.of(context).primaryColor),
                insets: EdgeInsets.symmetric(horizontal: 40.0),
              ),
              tabs: myTabs,
              labelColor: Theme.of(context).primaryColor,
              indicatorColor: Theme.of(context).primaryColor,
            ),
            body: TabBarView(children: [
              renderBio(profile),
              renderRecommendation(profile),
              renderPhotoGrid(),
            ]),
          ),
        )),
      ],
    );
  }

  renderPhotoGrid() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            itemCount: profile.data.profilePhotos.photosList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 6.0, mainAxisSpacing: 6.0),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GalleryViewer(
                                images: profile.data.profilePhotos.photosList,
                              )),
                    );
                  },
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Stack(
                        children: [
                          Container(
                              height: double.infinity,
                              child: CustomNetworkImage(
                                  imageUrl: profile.data.profilePhotos
                                      .photosList[index].url)),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                height: 30,
                                width: double.infinity,
                                child: MaterialButton(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.8),
                                  onPressed: () {
                                    showDeleteImageAlert(index);
                                  },
                                  child: Text("delete".tr(),
                                      style: deleteAlbumPhotoStyle),
                                )),
                          ),
                        ],
                      )));
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

  renderBio(Profile profile) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(
                          left: 30, top: 15, right: 30, bottom: 5),
                      child: Text(
                        "full_name".tr(),
                        style: bioHeaderStyle,
                      )),
                ),
                Container(
                    height: 30,
                    margin: EdgeInsets.only(left: 10, top: 10),
                    child: OutlinedButton.icon(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                      label: Text("edit".tr(),
                          style: TextStyle(
                              fontSize: 11,
                              fontFamily: KOFI_REGULAR,
                              color: Theme.of(context).primaryColor)),
                      onPressed: () {
                        navigateToBio(context);
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                            width: 2.0, color: Theme.of(context).primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                    )
                    // MaterialButton(
                    //   shape: RoundedRectangleBorder(

                    //       borderRadius: new BorderRadius.circular(30.0)),
                    //   color: Colors.white,
                    //   onPressed: () {},
                    //   child: Text("edit".tr(),
                    //       style: TextStyle(
                    //           fontSize: 11,
                    //           fontFamily: KOFI_REGULAR,
                    //           color: Colors.white)),
                    // ),
                    ),
              ],
            ),
            Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                child: Text(
                    profile.data.fullName != null ? profile.data.fullName : "",
                    style: pagerTabTextStyle)),
            Container(
                margin: EdgeInsets.only(left: 30, top: 20, right: 30),
                child: Text(
                  "bio".tr(),
                  style: bioHeaderStyle,
                )),
            Container(
                margin: EdgeInsets.only(left: 30, bottom: 15, right: 30),
                child: Text(profile.data.bio != null ? profile.data.bio : "",
                    style: pagerTabTextStyle)),
          ],
        ),
      ),
    );
  }

  void navigateToBio(BuildContext context) async {
    var response = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BioPage(
                fullname: profile.data.fullName, bio: profile.data.bio)));

    if (response == "OK") {
      getUserProfile();
    }
  }

  Future<void> showDeleteImageAlert(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('delete_photo'.tr(), style: bottomTabStyle),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('delete_msg'.tr(), style: bottomTabStyle),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ok'.tr(), style: bottomTabStyle),
              onPressed: () {
                Navigator.of(context).pop();

                deleteGridPic(index);
              },
            ),
            TextButton(
              child: Text('cancel'.tr(), style: bottomTabStyle),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
