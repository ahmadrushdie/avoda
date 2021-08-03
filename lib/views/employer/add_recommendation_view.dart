import 'package:flutter/material.dart';
import 'package:flutter_app/constants/apis_constants.dart';
import 'package:flutter_app/constants/fonts.dart';
import 'package:flutter_app/network/network_client.dart';
import 'package:flutter_app/utils/tool_bar_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/views/common/loading_dialog.dart';
import 'package:flutter_app/views/common/toast.dart';

class AddRecommendationPage extends StatefulWidget {
  AddRecommendationPage({Key key, this.workerId}) : super(key: key);

  String workerId;

  @override
  _AddRecommendationPageState createState() => _AddRecommendationPageState();
}

class _AddRecommendationPageState extends State<AddRecommendationPage> {
  String recommendation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ToolBarHelper.setToolbarTitle("add_recomendation".tr()),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: TextFormField(
                    initialValue: recommendation,
                    style: TextStyle(fontFamily: KOFI_REGULAR, fontSize: 14),
                    onChanged: (text) {
                      setState(() {
                        recommendation = text;
                      });
                    },
                    maxLines: null,
                    minLines: 5,
                    decoration: InputDecoration(
                      labelText: 'desc'.tr(),
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
                      if (recommendation != null && recommendation.length > 0) {
                        addRecommendation();
                      } else {
                        ToastUtil.showToast("please_fill_data".tr());
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

  addRecommendation() async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    DialogUtil.showLoadingDialog(context);
    var params = {"text": recommendation};
    var response = await NetworkClient.getInstance().request(
        requestType: RequestType.POST,
        path: WRITE_REFRENCE + widget.workerId,
        parameter: params);
    Navigator.pop(context);
    if (response.statusCode == 200) {
      Navigator.pop(context);
    }
  }
}
