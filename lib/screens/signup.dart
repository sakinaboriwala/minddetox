import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mind_detox/utils/constants.dart';
import 'package:mind_detox/screens/auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name;
  String gender;
  String age;
  String email;
  String password;
  bool _isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: Center(
            child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PlayFair Display'),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  nameField(),
                  genderField(),
                  ageField(),
                  emailField(),
                  passwordField(),
                  signUpButton(),
                  loginButton(),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  Widget nameField() {
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
            name = value;
          });
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(2),
            icon: Icon(
              Icons.person,
              size: 14,
            ),
            hintText: 'Name',
            hintStyle: TextStyle(fontSize: 12),
            border: InputBorder.none),
      ),
    );
  }

  Widget genderField() {
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
            gender = value;
          });
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(2),
            icon: Icon(
              Icons.favorite,
              size: 14,
            ),
            hintText: 'Gender',
            hintStyle: TextStyle(fontSize: 12),
            border: InputBorder.none),
      ),
    );
  }

  Widget ageField() {
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
            age = value;
          });
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(2),
            icon: Icon(
              Icons.person,
              size: 14,
            ),
            hintText: 'Age',
            hintStyle: TextStyle(fontSize: 12),
            border: InputBorder.none),
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

  Widget passwordField() {
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
            password = value;
          });
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(2),
            icon: Icon(
              Icons.lock,
              size: 14,
            ),
            hintText: 'Password',
            hintStyle: TextStyle(fontSize: 12),
            border: InputBorder.none),
      ),
    );
  }

  Widget signUpButton() {
    Map<dynamic, dynamic> responseBody = Map();
    return FlatButton(
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });
        _formKey.currentState.save();
        http.Response response = await http
            .post(Settings.SERVER_URL + 'api/signup.php', body: {
          'name': name,
          'gender': gender,
          'age': age,
          'email': email,
          'password': password
        });
        setState(() {
          _isLoading = false;
        });
        if (json.decode(response.body) != null) {
          responseBody = json.decode(response.body);

          if (responseBody['status'] == 0) {
            MaterialPageRoute route =
                MaterialPageRoute(builder: (context) => AuthenticationScreen());
            Navigator.of(context).pushReplacement(route);
          }
        } else {
          _scaffoldKey.currentState
              .showSnackBar(SnackBar(content: Text(responseBody['msg'])));
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
        child: _isLoading
            ? CupertinoActivityIndicator()
            : Container(
                child: Text('REGISTER', style: TextStyle(color: Colors.white))),
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
