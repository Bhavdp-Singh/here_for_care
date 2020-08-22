import 'package:flutter/material.dart';
import 'package:here_for_care/widgets/dialogflow/dialog_flow.dart';
class SignedInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: InkWell(
          onTap: () =>  Navigator.of(context).pushReplacementNamed(DialogFlow.routeName),
          child: Text('Ok'),
        ),
      ),
    );
  }
}
