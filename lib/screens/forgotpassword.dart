import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mind_detox/utils/constants.dart';
import 'package:mind_detox/screens/auth.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ResetPasswordState();
  }
}

class _ResetPasswordState extends State<ResetPassword> {
  String email = '';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'RESET PASSWORD',
                        style: TextStyle(
                            fontFamily: 'PlayFair Display',
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 15),
                      ),
                    ),
                    SizedBox(height: 20),
                    emailField(),
                    sendButton(),
                    loginButton()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget emailField() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(width: 1),
          shape: BoxShape.rectangle),
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      padding: EdgeInsets.all(12),
      child: TextFormField(
        onSaved: (String value) {
          setState(() {
            email = value;
          });
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(2),
            icon: Icon(
              Icons.email,
              size: 14,
            ),
            hintText: 'Email',
            hintStyle: TextStyle(fontSize: 12),
            border: InputBorder.none),
      ),
    );
  }

  Widget sendButton() {
    Map<String, dynamic> responseBody = Map();
    return FlatButton(
      onPressed: () async {
        _formKey.currentState.save();
        http.Response response = await http.post(
            Settings.SERVER_URL + 'api/forgetpwd.php',
            body: {'email': email});
        setState(() {
          responseBody = json.decode(response.body);
        });
        if (json.decode(response.body) != null) {
          _key.currentState.showSnackBar(SnackBar(
            content: Text(responseBody['msg']),
          ));
        } else {
          _key.currentState.showSnackBar(SnackBar(
            content: Text('Something went wrong, please try again.'),
          ));
        }
        print(json.decode(response.body));
      },
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            shape: BoxShape.rectangle,
            color: Colors.black),
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        padding: EdgeInsets.all(12),
        alignment: Alignment.center,
        child: Container(
            child: Text('SEND NOW', style: TextStyle(color: Colors.white))),
      ),
    );
  }

  Widget loginButton() {
    return FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.arrow_back_ios,
              size: 15,
            ),
            Text('Login')
          ],
        ));
  }
}
