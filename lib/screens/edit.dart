import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
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
          Container(
            margin: EdgeInsets.only(top: 17, right: 10),
            child: Text('Save'),
          ),
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
                maxLines: 4,
                obscureText: true,
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
              // Map<String, dynamic> responseBody = Map();
              // final SharedPreferences prefs =
              //     await SharedPreferences.getInstance();
              // http.post(Settings.SERVER_URL + 'api/changepwd.php',
              //     body: {
              //       'userid': prefs.getString('userId'),
              //       'password': newPassword
              //     }).then((response) {
              //   responseBody = json.decode(response.body);

              //   if (json.decode(response.body) != null &&
              //       responseBody['status'] == 0) {
              //     _key.currentState.showSnackBar(SnackBar(
              //       content: Text(responseBody['msg']),
              //     ));
              //     setState(() {
              //       // modifyPassword = false;
              //     });
              //   } else {
              //     _key.currentState.showSnackBar(SnackBar(
              //       content: Text(
              //           'Something went wrong, please try again.'),
              //     ));
              //   }
              // });
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
                      color: Colors.white, fontFamily: 'Playfair Display', fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
