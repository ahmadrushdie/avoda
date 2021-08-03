import 'package:flutter/material.dart';
import 'package:flutter_app/constants/fonts.dart';

class ToolBarHelper {
  static Text setToolbarTitle(String text) {
    return Text(text, style: TextStyle(fontFamily: KOFI_REGULAR, fontSize: 15));
  }
}
