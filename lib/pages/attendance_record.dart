import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final db = Firestore.instance;

  DateTime myDate;
  String pickedDate = DateTime.now().toString();
  void showPicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      setState(() {
        myDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Record'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: RaisedButton(
                onPressed: showPicker,
                child: Text('Select Date'),
              ),
            ),
            Text("Selected Date : $myDate"),
            Divider(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: db.collection('students').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.documents[index];
                        String res = ds['attendance'].toString();
                        return Container(
                          /* decoration: new BoxDecoration(
                color: Colors.red
              ), */
                          color: res == 'Absent' ? Colors.red : Colors.green,
                          child: ListTile(
                            title: Text(
                              ds['rollNo'].toString() +
                                  ". " +
                                  ds['student name'].toString().toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            leading: Icon(Icons.person, color: Colors.black),
                            trailing: Text(res),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return CircularProgressIndicator();
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
