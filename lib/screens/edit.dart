import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:mind_detox/utils/constants.dart';

class EditProfileScreen extends StatefulWidget {
  String username;
  EditProfileScreen(this.username);
  @override
  State<StatefulWidget> createState() {
    return _EditProfileScreenState();
  }
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String description;

  @override
  initState() {
    setDescripiton();
    super.initState();
  }

  setDescripiton() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      description = prefs.getString('description') == null
          ? ''
          : prefs.getString('description');
    });
  }

  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    print(description);
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.only(top: 17, left: 10),
            child: Text('Cancel'),
          ),
        ),
        title: Text(
          'PROFILE',
          style: TextStyle(fontFamily: 'Playfair Display', fontSize: 15),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              saveEdit();
            },
            child: Container(
              margin: EdgeInsets.only(top: 17, right: 10),
              child: Text('Save'),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(widget.username),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: TextEditingController()..text = description,
                maxLines: 4,
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Description',
                ),
              ),
            ),
          ),
          FlatButton(
            onPressed: () async {
              saveEdit();
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
      ),
    );
  }

  saveEdit() async {
    Map<String, dynamic> responseBody = Map();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    http.post(Settings.SERVER_URL + 'api/updateprofile.php', body: {
      'userid': prefs.getString('userId'),
      'name': prefs.getString('name'),
      'email': prefs.getString('email'),
      'gender': prefs.getString('gender'),
      'description': description,
      'age': prefs.getString('age')
    }).then((response) {

      responseBody = json.decode(response.body);
      print(responseBody);
      if (json.decode(response.body) != null && responseBody['status'] == 0) {
        prefs.setString('description', description);
        _key.currentState.showSnackBar(SnackBar(
          content: Text(responseBody['msg']),
        ));
      } else {
        _key.currentState.showSnackBar(SnackBar(
          content: Text('Something went wrong, please try again.'),
        ));
      }
    });
  }
}
