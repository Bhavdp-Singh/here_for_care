import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:flutter_dialogflow/utils/language.dart';
import 'package:flutter_dialogflow/v2/auth_google.dart';
import 'chat_bot.dart';
//import 'package:flutter_dialogflow/flutter_dialogflow.dart';


class DialogFlow extends StatefulWidget {

  static const routeName = '/dialogflow';
  DialogFlow({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DialogFlowState createState() => new _DialogFlowState();
}

class _DialogFlowState extends State<DialogFlow> {
  final List<ChatBot> _messages = <ChatBot>[];
  final TextEditingController _textController = new TextEditingController();

  Widget _queryInputWidget(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _submitQuery,
                decoration: InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _submitQuery(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void _dialogFlowResponse(query) async {
    _textController.clear();
     AuthGoogle authGoogle =  await AuthGoogle(fileJson: "assets/here-for-care-387ab21385e3.json").build();
    Dialogflow dialogFlow =  Dialogflow( authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogFlow.detectIntent(query);
    ChatBot message = ChatBot(
      text: response.getMessage() ?? CardDialogflow(response.getListMessage()[0]).title,
      name: "Mela Babu",
      type: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _submitQuery(String text) {
    _textController.clear();
    ChatBot message = new ChatBot(
      text: text,
      name: "B",
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    _dialogFlowResponse(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ChatBot"),
      ),
      body: Column(children: <Widget>[
        Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true, //To keep the latest messages at the bottom
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            )),
        Divider(height: 1.0),
        Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _queryInputWidget(context),
        ),
      ]),
    );
  }
}

