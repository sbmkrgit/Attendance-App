import 'package:attendance_app/pages/AddStudent.dart';
import 'package:attendance_app/pages/MarkAttendance.dart';
import 'package:attendance_app/pages/attendance_record.dart';
import 'package:attendance_app/pages/profile_page.dart';
import 'package:attendance_app/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('Home Screen'),
        ),
        body: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: CircleAvatar(
                  radius: 120,
                  child: ClipOval(
                    //borderRadius:BorderRadius.circular(70),
                    child: Image.asset(
                      'images/attend2.png',
                      width: 200,
                      height: 250,
                      //fit: BoxFit.cover,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text('Smart Attendance !!',
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddStudent()),
                  );
                },
                child: Container(
                  width: 300,
                  height: 100,
                  child: Card(
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        "Add/Edit Student",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MarkAttendance()),
                  );
                },
                child: Container(
                  width: 300,
                  height: 100,
                  child: Card(
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        "Mark Attendance",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Stack(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 18, top: 10),
                      child: CircleAvatar(
                        radius: 55,
                        child: ClipOval(
                          //borderRadius:BorderRadius.circular(70),
                          child: Image.asset(
                            'images/person.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        backgroundColor: Colors.black,
                      ),
                    ),
                    Positioned(
                      bottom: 10.0,
                      left: 16.0,
                      child: Text("Welcome to Smart Attendance !!",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold)),
                    ),
                  ])),
              /* UserAccountsDrawerHeader(
                  accountEmail: Text("${user?.email}"),
                  accountName: null /*Text("${user?.displayName}"*/), */
              ListTile(
                title: Text('Profile'),
                leading: Icon(Icons.person),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                },
              ),
              ListTile(
                title: Text('Attendance Record'),
                leading: Icon(Icons.date_range),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Attendance()),
                  );
                },
              ),
              new Divider(),
              ListTile(
                title: Text('Log Out !!'),
                leading: Icon(Icons.lock),
                onTap: () {
                  signOut();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
