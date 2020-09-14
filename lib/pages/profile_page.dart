import 'package:attendance_app/pages/home_page.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  static const String routeName = '/profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("Profile Page"),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              })),
      body: new Center(
        child: new Text("this is profile page"),
      ),
    );
  }
}
