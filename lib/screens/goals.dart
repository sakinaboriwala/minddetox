import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mind_detox/utils/constants.dart';
import 'package:mind_detox/models/goal.dart';
// import 'package:mind_detox/screens/playerscreen.dart';
import 'package:mind_detox/screens/player.dart';
import 'package:mind_detox/screens/player_widget.dart';

class GoalsScreen extends StatefulWidget {
  final String title;
  GoalsScreen(this.title);
  @override
  State<StatefulWidget> createState() {
    return _GoalsScreenState();
  }
}

class _GoalsScreenState extends State<GoalsScreen> {
  bool _isLoading = true;
  List<Goal> goalTitles = List();
  @override
  void initState() {
    super.initState();
    getGoalsList();
  }

  getGoalsList() {
    List<dynamic> responseBody;
    http.post(Settings.SERVER_URL + 'api/goalslist.php',
        body: {'goal_type': widget.title}).then((response) {
      responseBody = json.decode(response.body);
      if (responseBody != null) {
        setState(() {
          _isLoading = false;
          responseBody.forEach((goal) {
            goalTitles.add(Goal(
                title: goal['title'],
                featureImage: goal['feature_img'],
                audio: goal['audio']));
          });
        });
      }
      print("responseBody");
      print(responseBody);
    });
  }

  Widget moodContainer(int index) {
    return GestureDetector(
        onTap: () {
          MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => PlayerScreen(goalTitles[index]));
              // builder: (context) => PlayerWidget(url: goalTitles[index].audio,));
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

                   Colors.white])),
          child: Text(
            goalTitles[index].title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontFamily: 'PlayFair Display',
            ),
            textAlign: TextAlign.center,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title,
            style: TextStyle(fontFamily: 'PlayFair Display')),
      ),
      body: _isLoading
          ? Center(child: CupertinoActivityIndicator())
          : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return moodContainer(index);
              },
              itemCount: goalTitles.length,
            ),
    );
  }
}
