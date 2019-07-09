import 'package:flutter/material.dart';

import 'package:mind_detox/screens/about.dart';
import 'package:mind_detox/screens/profile.dart';
import 'package:mind_detox/screens/settings.dart';
import 'package:mind_detox/screens/contact.dart';

class MenuScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MoodScreenState();
  }
}

class _MoodScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              MaterialPageRoute route = MaterialPageRoute(
                  builder: (BuildContext context) => SettingsScreen());
              Navigator.of(context).push(route);
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Mood Menu',
                style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 20,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (context) => ProfileScreen());
                Navigator.of(context).push(route);
              },
              child: Text(
                'Profile',
                style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 20,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (context) => AboutScreen());
                Navigator.of(context).push(route);
              },
              child: Text(
                'About',
                style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 20,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (context) => ContactScreen());
                Navigator.of(context).push(route);
              },
              child: Text(
                'Contact Us',
                style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 20,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
