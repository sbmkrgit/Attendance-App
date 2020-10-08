import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddStudent extends StatefulWidget {
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final db = Firestore.instance;
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String _studentName;
  String _studentRollNo;
  bool isUpdate = false;
  String docIdToUpdate;
  final _studentNameController = TextEditingController();
  final _studentRollNoController = TextEditingController();

  clearForm() {
    setState(() {
      isUpdate = false;
      docIdToUpdate = null;
      _studentNameController.text = "";
      _studentRollNoController.text = "";
    });
  }

  Future<void> addStudent() async {
    await db.collection("students").add({
      'name': _studentName,
      'rollNo': int.parse(_studentRollNo),
    }).then((documentReference) {
      print(documentReference.documentID);
      clearForm();
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> editStudent() async {
    await db.collection("students").document(docIdToUpdate).updateData({
      'name': _studentName,
      'rollNo': int.parse(_studentRollNo),
    }).then((documentReference) {
      clearForm();
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> deleteStudent(DocumentSnapshot doc) async {
    db.collection("students").document(doc.documentID).delete();
    clearForm();
  }

  generateStudentList(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map<Widget>(
          (doc) => new ListTile(
            title: new Text(doc["name"]),
            subtitle: new Text(
              doc["rollNo"].toString(),
            ),
            trailing: Container(
              width: 100,
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _studentNameController.text = doc["name"];
                        _studentRollNoController.text = doc["rollNo"].toString();
                        docIdToUpdate = doc.documentID;
                        isUpdate = true;
                      });
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      deleteStudent(doc);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Student"),
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _formStateKey,
            autovalidate: true,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Student Name';
                      }
                      if (value.trim() == "")
                        return "Only Space is Not Valid!!!";
                      return null;
                    },
                    onSaved: (value) {
                      _studentName = value;
                    },
                    controller: _studentNameController,
                    decoration: InputDecoration(
                        focusedBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Colors.green,
                                width: 2,
                                style: BorderStyle.solid)),
                        labelText: "Student Name",
                        icon: Icon(
                          Icons.business_center,
                          color: Colors.green,
                        ),
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                          color: Colors.green,
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter RollNo';
                      }
                      if (value.trim() == "")
                        return "Only Space is Not Valid!!!";
                      return null;
                    },
                    onSaved: (value) {
                      _studentRollNo = value;
                    },
                    controller: _studentRollNoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        focusedBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Colors.green,
                                width: 2,
                                style: BorderStyle.solid)),
                        labelText: "RollNo",
                        icon: Icon(
                          Icons.dialpad,
                          color: Colors.green,
                        ),
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                          color: Colors.green,
                        )),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                color: Colors.green,
                child: Text(
                  (isUpdate ? 'UPDATE STUDENT' : 'ADD NEW STUDENT'),
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (isUpdate) {
                    if (_formStateKey.currentState.validate()) {
                      _formStateKey.currentState.save();
                      editStudent();
                    }
                  } else {
                    if (_formStateKey.currentState.validate()) {
                      _formStateKey.currentState.save();
                      addStudent();
                    }
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              RaisedButton(
                color: Colors.red,
                child: Text(
                  (isUpdate ? 'CANCEL UPDATE' : 'CLEAR'),
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  clearForm();
                },
              ),
            ],
          ),
          const Divider(
            height: 5.0,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: db.collection("students").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return new Text("There is no expense");
              return Expanded(
                child: new ListView(
                  children: generateStudentList(snapshot),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
