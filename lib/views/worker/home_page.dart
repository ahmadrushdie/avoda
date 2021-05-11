import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/utils/fonts.dart' as Constants;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/views/worker/profile.dart';

class WorkerHomePage extends StatefulWidget {
  WorkerHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  String title;

  @override
  _WorkerHomePageState createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  int selectedIndex = 0;

  var bottomTabStyle = TextStyle(fontFamily: Constants.KOFI_BOLD, fontSize: 13);

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _widgetOptions = <Widget>[
    Text(
      'Messages',
    ),
    Text(
      'Jobs',
    ),
    ProfilePage(),
  ];

  String getTitleByTabIndex(int index) {
    switch (index) {
      case 0:
        return "Adds";
        break;
      case 1:
        return "Search";
        break;

      case 2:
        return "Messages";
        break;
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
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title,
      //       style: TextStyle(
      //           fontFamily: Constants.KOFI_REGULAR,
      //           fontSize: 16,
      //           color: Colors.white)),
      // ),

      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.message), label: "messages".tr()),
          BottomNavigationBarItem(
            icon: Icon(Icons.engineering),
            label: 'jobs'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: "account".tr(),
          ),
        ],
        currentIndex: selectedIndex,
        selectedLabelStyle: bottomTabStyle,
        unselectedLabelStyle: bottomTabStyle,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
