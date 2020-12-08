import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddStudent extends StatefulWidget {
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser user;
  initUser() async {
    user = await _auth.currentUser();
    setState(() {
      collection = user.email;
    });
  }

  String collection;
  CollectionReference ref = Firestore.instance.collection("students");

  bool present = false;
  final db = Firestore.instance;
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String _studentName;
  String _studentRollNo;
  String motherName="";
  String fatherName="";
  String mobNo;
  String address;
  bool isUpdate = false;
  String docIdToUpdate;
  final _studentNameController = TextEditingController();
  final _studentRollNoController = TextEditingController();
  final motherNameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final mobNoController = TextEditingController();
  final addressController = TextEditingController();

  clearForm() {
    setState(() {
      isUpdate = false;
      docIdToUpdate = null;
      _studentNameController.text = "";
      _studentRollNoController.text = "";
      fatherNameController.text = "";
      motherNameController.text = "";
      mobNoController.text = "";
      addressController.text = "";
    });
  }

  Future<void> addStudent() async {
    /* await db.collection("students").add({
      'name': _studentName,
      'rollNo': int.parse(_studentRollNo),
      'attendance': "Absent",
    }).then((documentReference) {
      print(documentReference.documentID);
      clearForm();
    }).catchError((e) {
      print(e);
    }); */
    await ref.document(_studentRollNo).setData({
      'student name': _studentName,
      'rollNo': int.parse(_studentRollNo),
      'father name': fatherName,
      'mother name': motherName,
      'mobile no': mobNo,
      'address': address,
      'attendance': "Absent",
    }).then((documentReference) {
      clearForm();
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> editStudent() async {
    await db.collection("students").document(docIdToUpdate).updateData({
      'student name': _studentName,
      'rollNo': int.parse(_studentRollNo),
      'father name': fatherName,
      'mother name': motherName,
      'mobile no': mobNo,
      'address': address,
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
            leading: Icon(Icons.person_outline),
            title: Text(
              doc['rollNo'].toString() +
                  ". " +
                  doc['student name'].toString().toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            trailing: Container(
              width: 100,
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _studentNameController.text = doc["student name"];
                        _studentRollNoController.text =
                            doc["rollNo"].toString();
                        fatherNameController.text =
                            doc["father name"].toString();
                        motherNameController.text =
                            doc["mother name"].toString();
                        mobNoController.text = doc["mobile no"].toString();
                        addressController.text = doc["address"].toString();

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
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Add/Edit Student"),
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _formStateKey,
            autovalidate: true,
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
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
                        border: OutlineInputBorder(),
                        /* focusedBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Colors.green,
                                width: 2,
                                style: BorderStyle.solid)), */
                        labelText: "RollNo",
                        prefixIcon: Icon(Icons.confirmation_number)),
                  ),
                ),
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
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Student Name",
                        prefixIcon: Icon(Icons.person_add)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    /* validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Father Name';
                      }
                      if (value.trim() == "")
                        return "Only Space is Not Valid!!!";
                      return null;
                    }, */
                    onSaved: (value) {
                      fatherName = value;
                    },
                    controller: fatherNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Father Name",
                        prefixIcon: Icon(Icons.person)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    /* validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Mother Name';
                      }
                      if (value.trim() == "")
                        return "Only Space is Not Valid!!!";
                      return null;
                    }, */
                    onSaved: (value) {
                      motherName = value;
                    },
                    controller: motherNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Mother Name",
                        prefixIcon: Icon(Icons.person)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Mobile Number';
                      }
                      if (value.length != 10) {
                        return "Invalid Number !!";
                      }
                      if (value.trim() == "")
                        return "Only Space is Not Valid!!!";
                      return null;
                      
                    },
                    onSaved: (value) {
                      mobNo = value;
                    },
                    controller: mobNoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Mobile Number",
                        prefixIcon: Icon(Icons.phone)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Address';
                      }
                      if (value.trim() == "")
                        return "Only Space is Not Valid!!!";
                      return null;
                    },
                    onSaved: (value) {
                      address = value;
                    },
                    controller: addressController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Address",
                        prefixIcon: Icon(Icons.home)),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                color: Colors.blue,
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
            stream: db.collection("students").orderBy('rollNo').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return new Text("There is no Student");
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
