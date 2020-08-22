import 'package:flutter/material.dart';
import 'package:here_for_care/screens/go_to_bot.dart';

class ConfirmationScreen extends StatelessWidget with ChangeNotifier {

static const routeName ='/confirm';
final String name;
ConfirmationScreen({@required this.name});

  @override
  Widget build(BuildContext context) {
//  final _personName = ModalRoute.of(context).settings.arguments as String ;


    return Scaffold(
      body: AlertDialog(
        title: Text(' Welcome ${name} , Click Ok to proceed to the chat bot!') ,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
              child: Text('Cancel',
              style: TextStyle(
                color: Colors.grey,
              ),),
              onPressed: ()=>   Navigator.of(context).pop('/'),
            ),
            FlatButton(
              child: Text('OK',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),),
              onPressed:() => Navigator.of(context).pushReplacementNamed(GoToBot.routeName),
            )
          ],
        ),
      ),
    );
  }
}
