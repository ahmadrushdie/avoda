import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/chat/add_chat_view.dart';
import 'package:flutter_app/chat/chat_list_view.dart';
import 'package:flutter_app/constants/fonts.dart' as Constants;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/views/employer/employer_jobs_view.dart';
import 'package:flutter_app/views/employer/fav_workers.dart';
import 'package:flutter_app/views/employer/search_workers_view.dart';
import 'package:flutter_app/views/worker/posted_jobs.dart';
import 'package:flutter_app/views/worker/user_profile.dart';

class EmployerHomePage extends StatefulWidget {
  EmployerHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  String title;

  @override
  _EmployerHomePageState createState() => _EmployerHomePageState();
}

class _EmployerHomePageState extends State<EmployerHomePage> {
  int selectedIndex = 0;

  var widgets = [
    Container(child: ChatListView()),
    Container(child: EmployerJobsPage()),
    Container(child: SearchWorkers()),
    Container(child: FavWorkersPage()),
  ];

  var bottomTabStyle = TextStyle(
    fontFamily: Constants.KOFI_BOLD,
  );

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
          title: Text(widget.title,
              style: TextStyle(
                  fontFamily: Constants.KOFI_REGULAR,
                  fontSize: 16,
                  color: Colors.white)),
          actions: [
            TextButton.icon(
              icon: Icon(Icons.account_box),
              style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.resolveWith((state) => Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              label: Text("account".tr(),
                  style: TextStyle(
                      fontFamily: Constants.KOFI_REGULAR, fontSize: 10)),
            )
          ],
        ),
        body: widgets[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.message), label: "messages".tr()),
            BottomNavigationBarItem(
              icon: Icon(Icons.engineering),
              label: 'jobs'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "workers".tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_rate_rounded),
              label: "favourite".tr(),
            ),
          ],
          currentIndex: selectedIndex,
          selectedLabelStyle: bottomTabStyle,
          unselectedLabelStyle: bottomTabStyle,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.blueGrey,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          onTap: _onItemTapped,
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
