import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:here_for_care/screens/auth_screen.dart';
import 'package:here_for_care/screens/edit_details_screen.dart';
import 'package:here_for_care/screens/settings_screen.dart';

class AppDrawer extends StatefulWidget {
  final String name, url;

  AppDrawer(this.name, this.url);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
//  String name = "";
//  String url = "";
//   getDetails() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    setState(() {
//      name = prefs.getString('name');
//      url = prefs.getString('url');
//    });
//
//  }
//
//  @override
//  void initState() {
//    getDetails();
//    super.initState();
//  }
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.teal,
            height: 120,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.black26,
                    backgroundImage: isLoading ? CircularProgressIndicator:  NetworkImage(widget.url),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
//
                    child: Text(
                      widget.name,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Righteous'),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Your Details'),
              onTap: () {
                Navigator.of(context).pushNamed(EditDetailsScreen.routeName);
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
//                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(SettingsScreen.routename);
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
//                Navigator.of(context).pushReplacementNamed('/');
                Navigator.of(context)
                    .pushReplacementNamed(AuthScreen.routeName);
                FirebaseAuth.instance.signOut();
              }),
        ],
      ),
    );
  }
}
