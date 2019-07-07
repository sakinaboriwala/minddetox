import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AboutScreenState();
  }
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ABOUT US'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Image.asset('images/about.jpg'),
            Center(
              child: Text(
                'About',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'Welcome to Mind Detox Guided Meditations!',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                  'There is no right or wrong way to meditate. Simple close your eyes, listen to my voice and let your mind go wherever it needs to go. You can follow my words or let your mind drift. Just take time out for yourself as you learn to relax and let go. Guided meditation allows you to access a more mindful state with an end feeling as a goal. Each time you listen, it will get easier to connect to those feelings.'),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                  'I created these recordings because guided meditations have helped me so much through so many times in my life. I have helped many people pvercome difficulties using these meditation techniques and I hope they help you too.'),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text('For best results listen daily and with headphones.'),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                  'To keep in touch you can follow me on Instagram @fionalamb or visit my website www.fionalamb.com.'),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text('Happy meditating. :)'),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text('Disclaimer:'),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                  'ALways listen to these recordings when you are in a safe environment to relax fully. Do not listen whilst driving or operating machinery.'),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                  'The intention of these meditations is to help improve your mindset and shift limiting beliefs. There is no guarantee of outcome. The information provided is not intended to replace the services of a physician or doctor. It is not a substitute for professional medical advice.'),
            ),
                        SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                  'The contents of these recordings should not be reproduced, stored or retransmitted without any prior consent.'),
            ),
          ],
        ),
      ),
    );
  }
}
