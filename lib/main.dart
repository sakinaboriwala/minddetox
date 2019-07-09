import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mind_detox/screens/auth.dart';
import 'package:mind_detox/screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  bool loggedIn = false;
  bool loggedInFb = false;
  static final Map<int, Color> color = {
    50: Color.fromRGBO(193, 202, 212, .1),
    100: Color.fromRGBO(193, 202, 212, .2),
    200: Color.fromRGBO(193, 202, 212, .3),
    300: Color.fromRGBO(193, 202, 212, .4),
    400: Color.fromRGBO(193, 202, 212, .5),
    500: Color.fromRGBO(193, 202, 212, .6),
    600: Color.fromRGBO(193, 202, 212, .7),
    700: Color.fromRGBO(193, 202, 212, .8),
    800: Color.fromRGBO(193, 202, 212, .9),
    900: Color.fromRGBO(193, 202, 212, 1),
  };

  @override
  void initState() {
    checkLoggedIn();
    super.initState();
  }

  checkLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedIn = prefs.getBool('loggedIn');
      loggedInFb = prefs.getBool('loggedInFb');
    });
  }

  final MaterialColor colorCustom = MaterialColor(0xFFC1CAD4, color);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: colorCustom,
          fontFamily: 'Lato',
          canvasColor: colorCustom),
      home: loggedIn == null || loggedInFb == null
          ? AuthenticationScreen()
          : HomeScreen(),
    );
  }
}
