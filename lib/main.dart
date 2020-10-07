import 'package:attendance_app/pages/SplashScreen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Attendance App',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new SplashScreen(),
        );
  }
}
