import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'package:flutter/cupertino.dart';

import 'package:mind_detox/screens/auth.dart';
import 'package:mind_detox/utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool modifyPassword = false;
  bool loggedInFb = false;
  String newPassword = '';
  bool _isLoading = false;
  bool _isDeleteLoading = false;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    setLogin();
    super.initState();
  }

  setLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInFb = prefs.getBool('loggedInFb') != null
          ? prefs.getBool('loggedInFb')
          : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'SETTINGS',
          style: TextStyle(fontFamily: 'Playfair Display'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                )),
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
              ),
            ),
            !loggedInFb
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Password',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            modifyPassword = true;
                          });
                        },
                        child: Container(
                          height: 45,
                          width: 140,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              shape: BoxShape.rectangle,
                              color: Colors.black),
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Text('Modify',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Playfair Display',
                                  fontSize: 18)),
                        ),
                      ),
                    ],
                  )
                : Container(),
            modifyPassword
                ? Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          obscureText: true,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            hintText: 'Current Password',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          obscureText: true,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            hintText: 'New Password',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              newPassword = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () async {
                          Map<String, dynamic> responseBody = Map();
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          http.post(Settings.SERVER_URL + 'api/changepwd.php',
                              body: {
                                'userid': prefs.getString('userId'),
                                'password': newPassword
                              }).then((response) {
                            responseBody = json.decode(response.body);

                            if (json.decode(response.body) != null &&
                                responseBody['status'] == 0) {
                              _key.currentState.showSnackBar(SnackBar(
                                content: Text(responseBody['msg']),
                              ));
                              setState(() {
                                modifyPassword = false;
                              });
                            } else {
                              _key.currentState.showSnackBar(SnackBar(
                                content: Text(
                                    'Something went wrong, please try again.'),
                              ));
                            }
                          });
                        },
                        child: Container(
                          height: 45,
                          width: 140,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              shape: BoxShape.rectangle,
                              color: Colors.black),
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Text('Save',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Playfair Display',
                                  fontSize: 18)),
                        ),
                      ),
                    ],
                  )
                : Container(),
            SizedBox(
              height: 80,
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  _isLoading = true;
                });
                Map<dynamic, dynamic> responseBody = Map();

                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                if (!loggedInFb) {
                  http.post(Settings.SERVER_URL + 'api/logout.php', body: {
                    'email': prefs.getString('email')
                  }).then((response) {
                    responseBody = json.decode(response.body);
                    print('responseBody');
                    setState(() {
                      _isLoading = false;
                    });
                    if (json.decode(response.body) != null &&
                        responseBody['status'] == 0) {
                      prefs.clear();
                      MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) => AuthenticationScreen());
                      Navigator.of(context).pushReplacement(route);
                    } else {
                      _key.currentState.showSnackBar(SnackBar(
                        content:
                            Text('Something went wrong, please try again.'),
                      ));
                    }
                  });
                } else {
                  var facebookLogin = FacebookLogin();
                  facebookLogin.logOut();

                  prefs.clear();
                  MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => AuthenticationScreen());
                  Navigator.of(context).pushReplacement(route);
                }
              },
              child: _isLoading
                  ? CupertinoActivityIndicator()
                  : Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
            ),
            !loggedInFb
                ? GestureDetector(
                    onTap: () async {
                      setState(() {
                        _isDeleteLoading = true;
                      });
                      Map<dynamic, dynamic> responseBody = Map();

                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      http.post(Settings.SERVER_URL + 'api/deleteuser.php',
                          body: {
                            'userid': prefs.getString('userId')
                          }).then((response) {
                        setState(() {
                          _isDeleteLoading = false;
                        });
                        responseBody = json.decode(response.body);

                        if (json.decode(response.body) != null &&
                            responseBody['status'] == 0) {
                          prefs.clear();
                          MaterialPageRoute route = MaterialPageRoute(
                              builder: (context) => AuthenticationScreen());
                          Navigator.of(context).pushReplacement(route);
                        } else {
                          _key.currentState.showSnackBar(SnackBar(
                            content:
                                Text('Something went wrong, please try again.'),
                          ));
                        }
                      });
                    },
                    child: _isDeleteLoading
                        ? CupertinoActivityIndicator()
                        : Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Delete My Profile',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.orange),
                            ),
                          ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
