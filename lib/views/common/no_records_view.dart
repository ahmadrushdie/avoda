import 'package:flutter/material.dart';
import 'package:flutter_app/constants/fonts.dart';

class NoDataView extends StatelessWidget {
  NoDataView({Key key, @required this.text, this.iconPath}) : super(key: key);

  String text;
  String iconPath;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(
                  width: 140,
                  height: 140,
                  image: AssetImage("assets/images/no_data_icon.png"),
                  fit: BoxFit.fill),
              Text(text, style: TextStyle(fontFamily: KOFI_BOLD))
            ],
          ),
        ),
      ),
    );
  }
}
