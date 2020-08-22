//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:here_for_care/widgets/app_drawer.dart';
//class GetName extends StatefulWidget {
//
//
//  @override
//  _GetNameState createState() => _GetNameState();
//
//}
//class _GetNameState extends State<GetName> {
//  String _uid;
//  FirebaseUser currentUser;
//
//
//  Future getCurrentUser() async {
//    await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
//      setState(() {
//        this.currentUser = user;
//      });
//    });
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    getCurrentUser();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    _uid = currentUser.uid;
//
//    return StreamBuilder(
//        stream: Firestore.instance.collection('users').snapshots(),
//        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot ) {
//          if (!snapshot.hasData) {return CircularProgressIndicator(); }
//          return ListView(
//            shrinkWrap: true,
//            children: snapshot.data.documents.map((document){
//              Text( document['imageUrl'],
//                style: TextStyle(fontSize: 20,
//                  fontWeight: FontWeight.bold,
//                  color: Colors.white,
//                ),
//              );
//            }).toList(),
//              );
//            });
//
//  }
//}

//child:  FutureBuilder (
//                  future: Firestore.instance.collection('users').document('$uniqueId').get(),
//                  builder: (context,snapshot){
//                    if (!snapshot.hasData) {return CircularProgressIndicator(); }
//                    return Text(snapshot.data.document['[username']);
//                  },
//                ),