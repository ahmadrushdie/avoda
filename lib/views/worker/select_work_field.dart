import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/constants/apis_constants.dart';
import 'package:flutter_app/constants/fonts.dart';
import 'package:flutter_app/models/work_fields.dart';
import 'package:flutter_app/network/network_client.dart';
import 'package:flutter_app/utils/tool_bar_helper.dart';
import 'package:flutter_app/views/common/toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/views/worker/settings.dart';

typedef OnSelectFields = Function(List<WorkField>);

class SelectWorkField extends StatefulWidget {
  SelectWorkField({Key key, @required this.selectedFields, this.reloadcallBack})
      : super(key: key);
  OnSelectFields reloadcallBack;
  List<WorkField> selectedFields;
  @override
  _SelectWorkFieldState createState() => _SelectWorkFieldState();
}

class _SelectWorkFieldState extends State<SelectWorkField> {
  List<WorkField> workFields;

  var optionTextStyle = TextStyle(fontFamily: KOFI_REGULAR, fontSize: 15);
  var saveStyle =
      TextStyle(fontFamily: KOFI_REGULAR, fontSize: 13, color: Colors.white);

  @override
  void initState() {
    super.initState();
    getWorkingFields();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      var selected = workFields
                          .where((element) => element.isChecked)
                          .toList();
                      if (selected.length > 3) {
                        ToastUtil.showToast("please choose 3 items");
                      } else {
                        saveWorkingFields(selected);
                      }
                    },
                    child: Text(
                      "save".tr(),
                      style: saveStyle,
                    ))
              ],
              title: ToolBarHelper.setToolbarTitle("work_spesf".tr()),
            ),
            body: workFields != null
                ? ListView.builder(
                    itemCount: workFields.length,
                    itemBuilder: (context, index) {
                      return renderListView(index);
                    })
                : Center(child: CircularProgressIndicator())));
  }

  getWorkingFields() async {
    var response = await NetworkClient.getInstance()
        .request(requestType: RequestType.GET, path: GET_WORKING_FIELDS);

    if (response.statusCode == 200) {
      var workFieldsModel = WorkFields.fromJson(jsonDecode(response.body));
      if (workFieldsModel != null) {
        workFieldsModel.data.forEach((element) {
          widget.selectedFields.forEach((selected) {
            if (element.sId == selected.sId) {
              element.isChecked = true;
            }
          });
        });
      }
      setState(() {
        this.workFields = workFieldsModel.data;
      });
    }
  }

  saveWorkingFields(List<WorkField> fields) async {
    showLoaderDialog(context);
    List<String> ids = <String>[];
    fields.forEach((element) {
      ids.add(element.sId);
    });

    var params = <String, dynamic>{"fieldsIDs": ids};
    var response = await NetworkClient.getInstance().request(
        requestType: RequestType.PATCH,
        path: SET_WORKING_FIELDS,
        parameter: params);

    Navigator.pop(context);
    if (response.statusCode == 200) {
      widget.reloadcallBack(fields);
      Navigator.of(context).pop();
    }
  }

  Widget renderListView(int index) {
    var test = workFields[index].isChecked;
    return GestureDetector(
      onTap: () {
        workFields[index].isChecked = !workFields[index].isChecked;
        this.setState(() {
          workFields = workFields;
        });
      },
      child: Card(
        child: Row(
          children: [
            Checkbox(
                value: test,
                onChanged: (value) {
                  workFields[index].isChecked = !workFields[index].isChecked;
                  this.setState(() {
                    workFields = workFields;
                  });
                }),
            Text(workFields[index].arabicName, style: optionTextStyle),
          ],
        ),
      ),
    );
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
