import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MarkAttendance extends StatefulWidget {
  @override
  _MarkAttendanceState createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  final db = Firestore.instance;
  String status = "Absent";

  DateTime now = new DateTime.now();

  Future<void> attendanceMark() async {
    await db.collection("students").add({
      'attendance': "present",
    }).then((documentReference) {
      print(documentReference.documentID);
    }).catchError((e) {
      print(e);
    });
  }

  /* generateStudentList(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map<Widget>(
          (doc) => new ListTile(
              onTap: () {
                //to be implemented
              },
              title: new Text(
                doc["rollNo"].toString() +
                    ". " +
                    doc["name"].toString().toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              trailing: Checkbox(
                  value: false,
                  onChanged: (bool value) {
                    present = value;
                  })),
        )
        .toList();
  } */

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Mark Attendance"),
        ),
        body: Column(
          children: [
            Text(
              now.day.toString() +
                  "/" +
                  now.month.toString() +
                  "/" +
                  now.year.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Divider(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: db.collection('students').orderBy('rollNo').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.documents[index];
                        return Container(
                          /* decoration: new BoxDecoration(
                            color: Colors.red
                          ), */
                          child: ListTile(
                            title: Text(
                              ds['rollNo'].toString() +
                                  ". " +
                                  ds['student name'].toString().toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            onTap: () {
                              if (ds['attendance'].toString() == "Absent") {
                                db
                                    .collection("students")
                                    .document(ds.documentID)
                                    .updateData({
                                  "attendance": "Present",
                                  'time': DateTime.now()
                                });
                              } else {
                                db
                                    .collection("students")
                                    .document(ds.documentID)
                                    .updateData({
                                  "attendance": "Absent",
                                  'time': DateTime.now()
                                });
                              }
                            },
                            leading: Icon(Icons.person, color: Colors.black),
                            trailing: Text(ds['attendance']
                                .toString()), /* Checkbox(
                                value: present,
                                onChanged: (bool value) {
                                  setState(() {
                                    present = value;
                                  });
                                }), */
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
            Divider(),
            Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("SUBMIT"),
                ))
          ],
        ),
      ),
    );
  }
}
