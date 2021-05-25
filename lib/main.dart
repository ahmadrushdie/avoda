import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/views/favourite_jobs.dart';
import 'package:flutter_app/views/auth/login_intro.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/utils/PrefrenceUtil.dart';
import 'package:flutter_app/views/worker/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'extentions/extentions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  Locale locale;
  PrefrenceUtil.getLanguageLocale().then((value) {
    locale = value;
  });
  runApp(EasyLocalization(
      path: 'assets/locales',
      supportedLocales: [Locale('ar', ''), Locale('he', '')],
      startLocale: locale,
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  //
  //  Locale _locale;
  Widget startingView;

  Future<bool> checkIfUserLoggedin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jsonString = prefs.getString("user");
    if (jsonString != null) {
      User.authToken = json.decode(jsonString)["token"];
    }
    return jsonString != null;
  }

  @override
  Widget build(BuildContext context) {
    // _locale = new Locale("en", "");
    print(context.locale.toString());

    return MaterialApp(
        title: 'Flutter Demo',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primaryColor: HexColor.fromHex("#5c6bc0"),
          accentColor: HexColor.fromHex("#5c6bc0"),
        ),
        home: FutureBuilder<bool>(
          future: checkIfUserLoggedin(),
          builder: (buildContext, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data)
                return WorkerHomePage(
                  title: "home".tr(),
                );
              return LoginIntro();
            } else {
              return Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.amber),
                  child: CircularProgressIndicator());
            }
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index : School',
      style: optionStyle,
    ),
    Text(
      'Index : School',
      style: optionStyle,
    ),
    FavouriteJobs(),
    Text(
      'Index : School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      widget.title = getTitleByTabIndex(index);
    });
  }

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
      case 3:
        return "Favourite";
        break;
      case 4:
        return "Profile";
        break;
    }
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
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
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: _widgetOptions[_selectedIndex]),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).primaryColor,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Adds',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Favourite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
