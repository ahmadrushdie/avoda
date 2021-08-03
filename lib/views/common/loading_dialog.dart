import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter_app/constants/fonts.dart';

class DialogUtil {
  static showLoadingDialog(BuildContext context) {
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
