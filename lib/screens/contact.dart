import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mind_detox/utils/constants.dart';

class ContactScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ContactScreenState();
  }
}

class _ContactScreenState extends State<ContactScreen> {
  String name = '';
  String email = '';
  String message = '';
  String contact = '';

  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'CONTACT US',
          style: TextStyle(fontFamily: 'PlayFair Display'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.mail),
              title: Text('contact@fionalamb.com'),
              onTap: () {
                launch("mailto:contact@fionalamb.com");
              },
            ),
            ListTile(
              leading: Icon(Icons.call),
              title: Text('0208 144 6752'),
              onTap: () {
                launch("tel://02081446752");
              },
            ),
            ListTile(
              leading: Icon(Icons.open_in_browser),
              title: Text('www.fionalamb.com'),
              onTap: () {
                launch('www.fionalamb.com');
              },
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Harley Street, London'),
              onTap: () {
                _launchMaps();
              },
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Name',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    contact = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Contact No.',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    message = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Your Message',
                ),
              ),
            ),
            sendButton()
          ],
        ),
      ),
    );
  }

  Widget sendButton() {
    Map<String, dynamic> responseBody = Map();
    return FlatButton(
      onPressed: () async {
        http.Response response = await http.post(
            Settings.SERVER_URL + 'api/contactus.php',
            body: json.encode({
              'email': email,
              'name': name,
              'contact': contact,
              'message': message
            }));
        setState(() {
          responseBody = json.decode(response.body);
        });
        print(responseBody);
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
            child: Text('SEND', style: TextStyle(color: Colors.white))),
      ),
    );
  }

  _launchMaps() async {
    String googleUrl = 'comgooglemaps://?center=51.5202352,-0.1497155';
    String appleUrl = 'https://maps.apple.com/?sll=51.5202352,-0.1497155';
    if (await canLaunch("comgooglemaps://")) {
      print('launching com googleUrl');
      await launch(googleUrl);
    } else if (await canLaunch(appleUrl)) {
      print('launching apple url');
      await launch(appleUrl);
    } else {
      throw 'Could not launch url';
    }
  }
}
