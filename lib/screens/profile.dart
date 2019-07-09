import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mind_detox/screens/edit.dart';
import 'package:mind_detox/screens/settings.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = '';
  String image = '';
  bool loggedIn = false;
  bool loggedInFb = false;

  @override
  void initState() {
    super.initState();
    setName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'PROFILE',
          style: TextStyle(fontFamily: 'PlayFair Display'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            loggedInFb
                ? Container(
                    height: 200.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          image,
                        ),
                      ),
                    ),
                  )
                : Container(),
            Text(
              username,
              style: TextStyle(fontSize: 28, fontFamily: 'Playfair Display'),
            ),
            !loggedInFb
                ? FlatButton(
                    onPressed: () {
                      MaterialPageRoute route = MaterialPageRoute(
                          builder: (BuildContext context) =>
                              EditProfileScreen(username));
                      Navigator.of(context).push(route);
                    },
                    child: Container(
                      height: 45,
                      width: 180,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          shape: BoxShape.rectangle,
                          color: Colors.black),
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      padding: EdgeInsets.all(12),
                      alignment: Alignment.center,
                      child: Container(
                        child: Text(
                          'Edit your Profile',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Playfair Display'),
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  setName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('name');
      loggedIn = prefs.getBool('loggedIn');
      loggedInFb = prefs.getBool('loggedInFb');
      image = prefs.getString('image');
    });
  }
}
