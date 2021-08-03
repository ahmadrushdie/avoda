import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/constants/apis_constants.dart';
import 'package:flutter_app/constants/fonts.dart';
import 'package:flutter_app/extentions/extentions.dart';
import 'package:flutter_app/models/profile.dart';
import 'package:flutter_app/network/network_client.dart';
import 'package:flutter_app/views/common/toast.dart';
import 'package:flutter_app/views/worker/select_work_field.dart';
import 'package:flutter_tags/flutter_tags.dart';

typedef ReloadProfile = Function(Profile);

class SettingPage extends StatefulWidget {
  SettingPage({@required this.profile, this.callback}) : super();
  ReloadProfile callback;
  Profile profile;
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
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          renderLanguageTags(),
          renderWorkFieldsTags(),
        ]),
      ),
    );
  }

  renderLanguageTags() {
    var langs = widget.profile.data.languages;
    return Align(
        alignment: Alignment.topRight,
        child: Container(
            margin: EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 20),
            child: Column(children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    child: Text(
                      "languages".tr(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontFamily: KOFI_REGULAR, color: Colors.black),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Tags(
                    itemCount: langs.length, // required
                    itemBuilder: (int index) {
                      final item = langs[index];

                      return ItemTags(
                        // Each ItemTags must contain a Key. Keys allow Flutter to
                        // uniquely identify widgets.
                        key: Key(index.toString()),
                        index: index, // required
                        title: item == "Arabic" ? "عربي" : "عبري",
                        active: false,
                        pressEnabled: false,
                        removeButton: ItemTagsRemoveButton(
                          margin: EdgeInsets.only(right: 10),
                          onRemoved: () {
                            // setState(() {});
                            // langs.removeAt(index);
                            deleteLanguage(index, item, langs);
                            return true;
                          },
                        ), // OR null
                        elevation: 1,
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),

                        color: HexColor.fromHex("#ECF1FA"),
                        textStyle: TextStyle(
                          fontSize: 11,
                          fontFamily: KOFI_REGULAR,
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
                  IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        showLanguageAlert(widget.profile.data.languages);
                      }),
                ],
              )
            ])));
  }

  addLanguage(String language) async {
    showLoaderDialog(context);

    var data = <String, String>{
      'language': language,
    };
    var response = await NetworkClient.getInstance().request(
        requestType: RequestType.POST, path: ADD_LANGUAGE, parameter: data);
    Navigator.pop(context);
    if (response.statusCode == 200) {
      setState(() {
        widget.profile.data.languages.add(language);
      });

      widget.callback(widget.profile);

      ToastUtil.showToast("added successfully");
    } else {
      ToastUtil.showToast("error in add");
    }
  }

  showLanguageAlert(List<String> selectedLanguages) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          bool isArabicExist = false, isHebrowExist = false;
          selectedLanguages.forEach((element) {
            if (element == "Arabic") {
              isArabicExist = true;
            }

            if (element == "Hebrew") {
              isHebrowExist = true;
            }
          });
          var options = [
            {
              "lang": "arabic".tr(),
              "isCheck": isArabicExist,
              "value": "Arabic"
            },
            {"lang": "hebrew".tr(), "isCheck": isHebrowExist, "value": "Hebrew"}
          ];

          return AlertDialog(
              contentPadding: EdgeInsets.zero,
              title: Text('languages'.tr(), style: textStyle),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Container(
                  // Change as per your requirement
                  width: 300.0, // Change as per your requirement
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Row(children: [
                              Checkbox(
                                  value: options[index]["isCheck"],
                                  onChanged: (value) {
                                    if (value) {
                                      addLanguage(options[index]["value"]);
                                    } else {
                                      deleteLanguage(
                                          index,
                                          options[index]["value"],
                                          selectedLanguages);
                                    }
                                    options[index]["isCheck"] =
                                        !options[index]["isCheck"];
                                    var temp = options;
                                    setState(() => options = temp);
                                  }),
                              Text(options[index]["lang"], style: textStyle),
                            ]),
                          );
                        },
                      ),
                      Container(
                        height: 1.5,
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.grey.shade100),
                      ),
                      Container(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("cancel".tr(), style: textStyle),
                        ),
                      )
                    ],
                  ),
                );
              }));
        });
  }

  renderWorkFieldsTags() {
    var workfields = widget.profile.data.workFields;
    return Align(
        alignment: Alignment.topRight,
        child: Container(
            margin: EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 20),
            child: Column(children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    child: Text(
                      "work_spesf".tr(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontFamily: KOFI_REGULAR, color: Colors.black),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Tags(
                    itemCount: workfields.length, // required
                    itemBuilder: (int index) {
                      final item = workfields[index];

                      return ItemTags(
                        // Each ItemTags must contain a Key. Keys allow Flutter to
                        // uniquely identify widgets.
                        key: Key(index.toString()),
                        index: index, // required
                        title: item.getFieldName(context.locale.languageCode),
                        active: false,
                        pressEnabled: false,
                        elevation: 1,
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),

                        color: HexColor.fromHex("#ECF1FA"),
                        textStyle: TextStyle(
                          fontSize: 11,
                          fontFamily: KOFI_REGULAR,
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
                  IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectWorkField(
                                    selectedFields: workfields,
                                    reloadcallBack: (updateProfile) {
                                      setState(() {
                                        widget.profile.data.workFields =
                                            updateProfile;
                                      });
                                      widget.callback(widget.profile);
                                    })));
                      }),
                ],
              )
            ])));
  }

  void deleteLanguage(int index, String item, List<String> langs) async {
    showLoaderDialog(context);
    var params = <String, String>{"language": item};
    var response = await NetworkClient.getInstance().request(
        requestType: RequestType.DELETE,
        path: DELETE_LANGUAGE,
        parameter: params);

    Navigator.pop(context);
    if (response.statusCode == 200) {
      langs.removeAt(index);
      widget.callback(widget.profile);

      setState(() {
        widget.profile.data.languages = langs;
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
