import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:mind_detox/utils/constants.dart';
import 'package:mind_detox/screens/home.dart';
import 'package:mind_detox/screens/signup.dart';
import 'package:mind_detox/screens/forgotpassword.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthenticationScreenState();
  }
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  String email;
  String password;
  bool _isLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> responseBody = Map<String, dynamic>();
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
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
                            'MIND DETOX',
                            style: TextStyle(
                                fontFamily: 'PlayFair Display',
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: 15),
                          ),
                        ),
                        SizedBox(height: 20),
                        emailField(),
                        passwordField(),
                        loginButton(),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            MaterialPageRoute route = MaterialPageRoute(
                                builder: (context) => ResetPassword());
                            Navigator.of(context).push(route);
                          },
                          child: Text('Forgot your password?'),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        loginFacebookButton(),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'By using this App you agree with the terms of services',
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: GestureDetector(
            onTap: () {
              MaterialPageRoute route =
                  MaterialPageRoute(builder: (context) => SignUpScreen());
              Navigator.of(context).push(route);
            },
            child: Container(
              color: Colors.blueGrey.shade200,
              height: 70,
              child: Center(
                child: Text(
                  'Not yet registered? Sign up',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ),
        ));
  }

  void initiateFacebookLogin() async {
    var facebookLogin = FacebookLogin();
    var facebookLoginResult =
        await facebookLogin.logInWithReadPermissions(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        break;
      case FacebookLoginStatus.loggedIn:
        MaterialPageRoute route =
            MaterialPageRoute(builder: (context) => HomeScreen());
        Navigator.of(context).push(route);
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.accessToken.token}');

        var profile = json.decode(graphResponse.body);
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('name', profile['first_name']);
        prefs.setBool('loggedInFb', true);
        prefs.setString('image', profile['picture']['data']['url']);
        prefs.setBool('loggedIn', false);
        print(profile.toString());
        print(profile['first_name']);
        print("LoggedIn");
        break;
    }
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
        obscureText: true,
        onSaved: (String value) {
          setState(() {
            password = value;
          });
        },
        cursorColor: Colors.black,
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

  Widget loginFacebookButton() {
    return FlatButton(
      onPressed: () {
        initiateFacebookLogin();
      },
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            shape: BoxShape.rectangle,
            color: Colors.blue.shade900),
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        padding: EdgeInsets.all(12),
        alignment: Alignment.center,
        child:
            Text('Login with Facebook', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget loginButton() {
    return FlatButton(
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });
        _formKey.currentState.save();
        // HttpClient _client = new HttpClient();
        // _client.badCertificateCallback =
        //     (X509Certificate cert, String host, int port) => true;
        // var request =
        //     await _client.getUrl(Uri.parse("https://www.minddetox.app/"));
        // var response1 = await request.close();
        // print(response1.headers);
        http.Response response = await http.post(
            Settings.SERVER_URL + 'api/login.php',
            body: {'email': email, 'password': password});
        setState(() {
          _isLoading = false;
        });
        if (json.decode(response.body) != null) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          responseBody = json.decode(response.body);
          prefs.setString('email', responseBody['email']);
          prefs.setString('name', responseBody['name']);
          prefs.setString('userId', responseBody['userid']);
          prefs.setString('gender', responseBody['gender']);
          prefs.setString('age', responseBody['age']);
          prefs.setString('description', responseBody['description']);          
          prefs.setBool('loggedIn', true);
          prefs.setBool('loggedInFb', false);
          MaterialPageRoute route =
              MaterialPageRoute(builder: (context) => HomeScreen());
          Navigator.of(context).push(route);
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
        child: _isLoading
            ? CupertinoActivityIndicator()
            : Container(
                child: Text('LOGIN', style: TextStyle(color: Colors.white))),
      ),
    );
  }
}
