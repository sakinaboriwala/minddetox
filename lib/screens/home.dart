import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:mind_detox/screens/goals.dart';
import 'package:mind_detox/screens/menu.dart';
import 'package:mind_detox/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  bool subscribed;
  bool isLoading;
  HomeScreen({this.subscribed, this.isLoading});
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  List<String> moodTitles = List();

  @override
  initState() {
    super.initState();
    getMoods();
  }

  getMoods() {
    List responseBody = List();
    HttpClient _client = new HttpClient();
    _client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    // _client.get(host, port, path)

    http.get(Settings.SERVER_URL + 'api/moods.php').then((response) {
      responseBody = json.decode(response.body);
      if (responseBody != null) {
        responseBody.forEach((mood) {
          setState(() {
            moodTitles.add(mood['title']);
          });
        });
        _isLoading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            MaterialPageRoute route =
                MaterialPageRoute(builder: (context) => MenuScreen());
            Navigator.of(context).push(route);
          },
        ),
        title: Text(
          'HOW WOULD YOU LIKE TO FEEL?',
          style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 16,
              fontFamily: 'PlayFair Display'),
        ),
      ),
      body: _isLoading
          ? Center(child: CupertinoActivityIndicator())
          : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return moodContainer(moodTitles[index]);
              },
              itemCount: moodTitles.length,
            ),
    );
  }

  Widget moodContainer(String title) {
    return GestureDetector(
        onTap: () {
          MaterialPageRoute route =
              MaterialPageRoute(builder: (context) => GoalsScreen(title));
          Navigator.push(context, route);
        },
        child: Container(
          alignment: Alignment.center,
          height: 200,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                // Color(0xFFC1CAD4),
                Colors.blueGrey.shade200,
                Colors.white
              ])),
          child: Text(title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontFamily: 'Playfair Display')),
        ));
  }
}
