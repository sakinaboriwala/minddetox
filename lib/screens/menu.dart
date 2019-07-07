import 'package:flutter/material.dart';

import 'package:mind_detox/screens/about.dart';

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
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.settings),
        //     onPressed: () {},
        //   )
        // ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Text('MoodMenu'),
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {},
              child: Text('Profile'),
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
              child: Text('About'),
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {},
              child: Text('Contact Us'),
            ),
          ],
        ),
      ),
    );
  }
}
