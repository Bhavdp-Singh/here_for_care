import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:here_for_care/Providers/get_aadhar.dart';
import 'package:here_for_care/screens/auth_screen.dart';


class SettingsScreen extends StatefulWidget {
  static const routename = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

void _deleteUser() async{
   String _aadhar = GetAadhar().toString();

  await Firestore.instance.collection('details').document((await FirebaseAuth.instance.currentUser()).uid).delete();
   FirebaseUser user = await FirebaseAuth.instance.currentUser();
   user.delete();
       await  FirebaseStorage.instance.ref().child('user_aadhar_image').child('$_aadhar').delete().then((_) => print('Successfully deleted ' ));
   await  FirebaseStorage.instance.ref().child('user_image').child('$_aadhar').delete();


  Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);

}
void _dialogDelete() {
  showDialog(
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return new AlertDialog(
          content: Text(
            'Are you sure, you want to delete your account and wipe all data',
            style: TextStyle(fontSize: 20),),
          actions: <Widget>[
            Row(
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.teal)),
                  onPressed: () => Navigator.of(context).pop('/'),
                  color: Colors.teal,
                  textColor: Colors.white,
                  child: Text("No",
                      style: TextStyle(fontSize: 15)),
                ),
                 SizedBox(width: 30,),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.teal)),
                  onPressed: _deleteUser,
                  color: Colors.teal,
                  textColor: Colors.white,
                  child: Text("Yes",
                      style: TextStyle(fontSize: 15)),

                ),
              ],
            )
          ],
        );
      });
      }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        child: ListView(shrinkWrap: true, children: <Widget>[
          SingleChildScrollView(
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Card(
                  elevation: 10,
                  child: ListTile(
                    onTap: _dialogDelete,
                    leading: Icon(Icons.delete),
                    title: Text(
                      'Delete account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text('Delete account and wipe all data'),
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
