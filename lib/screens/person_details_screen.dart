import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:here_for_care/screens/auth_screen.dart';
import 'package:here_for_care/widgets/person/person_details.dart';
//import 'package:provider/provider.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import '../screens/auth_screen.dart';

class PersonDetailsScreen extends StatefulWidget {
  static const routeName = '/details';

  @override
  _PersonDetailsScreenState createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> with ChangeNotifier{
  var isLoading = false;


  saveDetails(String _name, String age, String phoneNo , String address ,String aadhar ,String _url) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('savings details of user $_name, $age $phoneNo, $address , $aadhar $_url');
    prefs.setString('name', '$_name');
    prefs.setString('age', '$age');
    prefs.setString('phoneNo', '$phoneNo');
    prefs.setString('address', '$address');
    prefs.setString('aadhar', '$aadhar');
    prefs.setString('_url', '$_url');

  }


  void _pressSubmit(
    String name,
    String age,
    String phone,
    String address,
    String aadhar,
    File aadharImage,
    BuildContext ctx,
  ) async {

    try {
      setState(() {
        isLoading = true;
      });

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_aadhar_image')
          .child(aadhar + '.jpg');

      await ref.putFile(aadharImage).onComplete;
      final url = await ref.getDownloadURL();

//      final uid = await Provider.of<AuthScreen>(context).getUid(user, context);
      saveDetails(name,age,phone,address,aadhar,url);

      await Firestore.instance.collection('users').document((await FirebaseAuth.instance.currentUser()).uid).updateData({
        'name': name,
        'age': age,
        'phoneNo' : phone,
        'aadharimageUrl': url,
        'address': address,
        'aadhar': aadhar,
      });
    } on PlatformException catch (err) {
      var message = 'An error occurred ,please check your details!';
      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Here for care'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Logout',
                      ),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
            },
          ),
        ],
      ),
      body: PersonDetails(_pressSubmit),
    );
  }
}
