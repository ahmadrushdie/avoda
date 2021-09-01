import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/constants/apis_constants.dart';
import 'package:flutter_app/constants/fonts.dart';
import 'package:flutter_app/models/work_fields.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/network/network_client.dart';
import 'package:flutter_app/utils/tool_bar_helper.dart';

class SelectSpecialization extends StatefulWidget {
  SelectSpecialization({Key key, this.workFieldId}) : super(key: key);

  String workFieldId;
  @override
  _SelectSpecializationState createState() => _SelectSpecializationState();
}

class _SelectSpecializationState extends State<SelectSpecialization> {
  List<WorkField> list;
  List<WorkField> workFields;

  @override
  void initState() {
    getWorkingFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: ToolBarHelper.setToolbarTitle("select_special".tr()),
        ),
        body: Container(
            child: list == null
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            right: 23.0, top: 8, bottom: 8),
                        child: Container(
                          child: Row(children: [
                            GestureDetector(
                              onTap: () {
                                makeSelection(list, index);
                                Navigator.pop(context, jsonEncode(list[index]));
                              },
                              child: Text(
                                  list[index].getFieldName(
                                      context.locale.languageCode),
                                  style: TextStyle(
                                      fontFamily: KOFI_REGULAR,
                                      color: list[index].isChecked
                                          ? Theme.of(context).primaryColor
                                          : Colors.black,
                                      fontSize: 15)),
                            )
                          ]),
                        ),
                      );
                    },
                  )));
  }

  void makeSelection(List<WorkField> list, int index) {
    var checked = list.where((element) => element.isChecked).toList();
    if (checked != null) {
      checked.forEach((element) {
        element.isChecked = false;
      });
    }
    // workFieldId = list[index].sId;
    // setState(() {
    //   workFieldName = list[index].getFieldName(context.locale.languageCode);
    // });
    // list[index].isChecked = true;
  }

  getWorkingFields() async {
    var response = await NetworkClient.getInstance()
        .request(requestType: RequestType.GET, path: GET_WORKING_FIELDS);

    if (response.statusCode == 200) {
      var workFieldsModel = WorkFields.fromJson(jsonDecode(response.body));
      if (workFieldsModel != null) {
        workFieldsModel.data.forEach((element) {
          if (element.sId == widget.workFieldId) {
            element.isChecked = true;
          }
        });
        setState(() {
          this.list = workFieldsModel.data;
        });
      }
    }
  }
}
