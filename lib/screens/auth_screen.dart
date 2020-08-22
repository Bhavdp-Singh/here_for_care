import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/person/auth_form.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget with ChangeNotifier {
  static const routeName ='auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();


}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var isLoading = false;

  saveNamePrefrences(String name, String url) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('savings details of user $name, $url');
    prefs.setString('name', '$name');
    prefs.setString('url', '$url');
  }
  void _submitAuthForm(
    String email,
    String username,
    String password,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    AuthResult authResult;

    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user.uid + '.jpg');


        await ref.putFile(image).onComplete;
        final url = await ref.getDownloadURL();

         saveNamePrefrences(username, url);
        print('name ande url is $username and $url ');

        await Firestore.instance.collection('users').document(authResult.user.uid).setData({
            'username': username,
            'email': email,
            'imageUrl': url,
          });
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred ,please check your credentials!';
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
      backgroundColor: Theme.of(context).primaryColor,
      body:  AuthForm(_submitAuthForm,isLoading,),
    );
  }
}
