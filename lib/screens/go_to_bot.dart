import 'package:flutter/material.dart';
import 'package:here_for_care/widgets/app_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/dialogflow/dialog_flow.dart';
class GoToBot extends StatefulWidget {
  static const routeName = '/gotobot';

  @override
  _GoToBotState createState() => _GoToBotState();
}

class _GoToBotState extends State<GoToBot> {
  String name = "";

  String url = "";
  bool isLoading = false;
  getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      url = prefs.getString('url');
      isLoading = true;
    });
    print('gettings details of user $name, $url');


  }

  @override
  void initState() {
    getDetails();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return isLoading ?
        Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Center(child: Text('Welcome')),
      ),
      drawer:  AppDrawer(name,url),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[

              Padding(
                padding: const EdgeInsets.all(15),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Press the chat icon at the bottom to proceed to the chat bot!",
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Icon(Icons.keyboard_arrow_down,
                      size: 40,
                      ),
                    ],
                  ),
                ),
              ),
              FloatingActionButton(
                materialTapTargetSize: MaterialTapTargetSize.padded,
                child: Center(
                  child: Icon(Icons.chat),
                ),
                elevation: 4.0,
                backgroundColor: Colors.blueAccent,
                onPressed: () =>
                    Navigator.of(context).pushNamed(DialogFlow.routeName),
              ),
            ]),

      ),
    ) : CircularProgressIndicator();
  }
}
