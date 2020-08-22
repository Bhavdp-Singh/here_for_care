import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class GetAadhar extends StatefulWidget {

  @override
  _GetAadharState createState() => _GetAadharState();
}

class _GetAadharState extends State<GetAadhar> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('users').snapshots(),
      builder: (context,snapshot) {
        if(!snapshot.hasData) return CircularProgressIndicator();
        final String name =  snapshot.data.documents[FirebaseAuth.instance.currentUser()]['aadhar'].toString();
        return Text(name,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 25,
          ),);

      },
    );
  }
}
