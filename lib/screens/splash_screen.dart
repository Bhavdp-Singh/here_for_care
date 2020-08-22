import 'package:flutter/material.dart';
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(100),
              child: Center(
                child: Text('Loading...'),
              ),
            ),
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}

