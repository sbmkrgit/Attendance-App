import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    user = await _auth.currentUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('My Profile'),
        ),
        body: Center(
            child: Column(
                /* mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, */
                children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: CircleAvatar(
                  radius: 120,
                  child: ClipOval(
                      //borderRadius:BorderRadius.circular(70),
                      child: Icon(
                    Icons.person,
                    size: 200,
                    color: Colors.white,
                  )
                      /* Image.asset(
                      'images/person.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ), */
                      ),
                  backgroundColor: Colors.blue,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text("${user?.email}",
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
              )
            ])));
  }
}
