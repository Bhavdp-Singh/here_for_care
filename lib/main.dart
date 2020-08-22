import 'package:flutter/material.dart';
import 'package:here_for_care/screens/edit_details_screen.dart';
import 'package:here_for_care/screens/go_to_bot.dart';
import 'package:here_for_care/screens/person_details_screen.dart';
import 'package:here_for_care/screens/settings_screen.dart';
import 'package:here_for_care/widgets/dialogflow/dialog_flow.dart';
import 'package:here_for_care/screens/auth_screen.dart';
import 'package:here_for_care/screens/confirmation_screen.dart';
import 'package:here_for_care/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Here For Care',
        theme: ThemeData(
          fontFamily: 'Raleway',
          primarySwatch: Colors.teal,
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.black,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (ctx, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return SplashScreen();
              } else if (userSnapshot.hasData) {
                return GoToBot();
              } else
                return AuthScreen();
            }),
        routes: {
          PersonDetailsScreen.routeName: (ctx) => PersonDetailsScreen(),
          AuthScreen.routeName : (ctx) => AuthScreen(),
         ConfirmationScreen.routeName : (ctx) => ConfirmationScreen(),
          DialogFlow.routeName: (ctx) => DialogFlow(),
          GoToBot.routeName: (ctx) => GoToBot(),
          EditDetailsScreen.routeName : (ctx) => EditDetailsScreen(),
          SettingsScreen.routename: (ctx) => SettingsScreen(),
        });
  }
}
