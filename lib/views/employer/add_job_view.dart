import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/constants/apis_constants.dart';
import 'package:flutter_app/constants/fonts.dart';
import 'package:flutter_app/models/work_fields.dart';
import 'package:flutter_app/network/network_client.dart';
import 'package:flutter_app/utils/tool_bar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/views/common/loading_dialog.dart';
import 'package:flutter_app/views/common/toast.dart';

class AddJobPage extends StatefulWidget {
  AddJobPage({Key key}) : super(key: key);

  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  List<WorkField> workFields;
  String workFieldId;
  String workFieldName = "";
  String workDesc;
  String workLocation;

  @override
  void initState() {
    getWorkingFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: ToolBarHelper.setToolbarTitle("add_job".tr()),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (workFields != null)
                  Container(
                      margin: EdgeInsets.only(top: 25, bottom: 25),
                      child: GestureDetector(
                        child: InputDecorator(
                          child: Text(workFieldName,
                              style: TextStyle(
                                fontFamily: KOFI_REGULAR,
                                fontSize: 13,
                              )),
                          decoration: InputDecoration(
                            labelText: 'specialization'.tr(),
                            hintText: "select_special".tr(),
                            hintStyle: TextStyle(
                                fontFamily: KOFI_REGULAR,
                                fontSize: 14,
                                color: Colors.black),
                            labelStyle: TextStyle(
                                fontFamily: KOFI_REGULAR, fontSize: 14),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        onTap: () {
                          showWokingFieldFilter(workFields);
                        },
                      )),
                Container(
                  height: 55,
                  child: TextFormField(
                    style: TextStyle(fontFamily: KOFI_REGULAR, fontSize: 14),
                    initialValue: workLocation,
                    onChanged: (text) {
                      setState(() {
                        workLocation = text;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'location'.tr(),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: TextFormField(
                    initialValue: workDesc,
                    style: TextStyle(fontFamily: KOFI_REGULAR, fontSize: 14),
                    onChanged: (text) {
                      setState(() {
                        workDesc = text;
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    onPressed: () {
                      if (validateData()) {
                        postJob(workFieldId, workLocation, workDesc);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  validateData() {
    if (workFieldId != null && workLocation != null && workDesc != null) {
      return true;
    } else {
      ToastUtil.showToast("please_fill_data".tr());
      return false;
    }
  }

  postJob(String field, String city, String text) async {
    DialogUtil.showLoadingDialog(context);
    var params = {"filedID": field, "city": city, "description": text};
    var response = await NetworkClient.getInstance().request(
        requestType: RequestType.POST, path: POST_JOB, parameter: params);
    Navigator.pop(context);
    if (response.statusCode == 200) {
      Navigator.pop(context, "reload");
    }
  }

  getWorkingFields() async {
    var response = await NetworkClient.getInstance()
        .request(requestType: RequestType.GET, path: GET_WORKING_FIELDS);

    if (response.statusCode == 200) {
      var workFieldsModel = WorkFields.fromJson(jsonDecode(response.body));
      if (workFieldsModel != null) {
        workFieldsModel.data.forEach((element) {
          if (element.sId == workFieldId) {
            element.isChecked = true;
          }
        });
        setState(() {
          this.workFields = workFieldsModel.data;
        });
      }
    }
  }

  showWokingFieldFilter(List<WorkField> list) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.zero,
              title: Text('specialization'.tr(),
                  style: TextStyle(fontFamily: KOFI_REGULAR)),
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
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                right: 23.0, top: 8, bottom: 8),
                            child: Column(
                              children: [
                                Row(children: [
                                  GestureDetector(
                                    onTap: () {
                                      makeSelection(list, index);
                                      Navigator.pop(context);
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
                              ],
                            ),
                          );
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 1.5,
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.grey.shade100),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("cancel".tr()),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }));
        });
  }

  void makeSelection(List<WorkField> list, int index) {
    var checked = list.where((element) => element.isChecked).toList();
    if (checked != null) {
      checked.forEach((element) {
        element.isChecked = false;
      });
    }
    workFieldId = list[index].sId;
    setState(() {
      workFieldName = list[index].getFieldName(context.locale.languageCode);
    });
    list[index].isChecked = true;
  }
}
