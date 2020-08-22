import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:here_for_care/screens/go_to_bot.dart';
import 'dart:io';
import 'package:here_for_care/widgets/person/profile_page_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditDetailsScreen extends StatefulWidget {
  static const routeName = 'editDetails';


  @override
  _EditDetailsScreenState createState() => _EditDetailsScreenState();
}

class _EditDetailsScreenState extends State<EditDetailsScreen>
    with SingleTickerProviderStateMixin  {
  bool isLoading = false;

  String user;
  String _url = "";


  getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _url = prefs.getString('url');
      isLoading = true;
    });
    print('gettings details of user $_url');
  }

    void _pressSubmit(String name,
      String age,
      String phone,
      String address,
      String aadhar,
      File aadharImage,
      BuildContext ctx,) async {
    try {
      setState(() {
        isLoading = true;
      });

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_aadhar_image')
          .child(aadhar + '.jpg');

      await ref
          .putFile(aadharImage)
          .onComplete;
      final url = await ref.getDownloadURL();

//      final uid = await Provider.of<AuthScreen>(context).getUid(user, context);

      await Firestore.instance
          .collection('details')
          .document((await FirebaseAuth.instance.currentUser()).uid)
          .updateData({
        'name': name,
        'age': age,
        'phoneNo': phone,
        'imageUrl': url,
        'address': address,
        'aadhar': aadhar,
      });
    }
    on PlatformException catch (err) {
      var message = 'An error occurred ,please check your details!';
      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme
            .of(context)
            .errorColor,
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
    Navigator.of(context).pushReplacementNamed(GoToBot.routeName);
  }

  AnimationController _controller;
  Animation<double> _heightFactorAnimation;

  double collapsedHeightFactor = 0.90;
  double expandedHeightFactor = 0.40;

  bool isAnimationCompleted = false;
  double screenheight = 0;

  @override
  void initState() {
    getDetails();
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _heightFactorAnimation =
        Tween<double>(begin: collapsedHeightFactor, end: expandedHeightFactor)
            .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  onBottomPartTap() {
    setState(() {
      if (isAnimationCompleted) {
        _controller.fling(velocity: -1);
      } else {
        _controller.fling(velocity: 1);
      }
      isAnimationCompleted = !isAnimationCompleted;
    });
  }



  Widget getWidget() {
    return Stack(fit: StackFit.expand, children: <Widget>[
      FractionallySizedBox(
        heightFactor: _heightFactorAnimation.value,
        alignment: Alignment.topCenter,
        child: Stack(fit: StackFit.expand, children: <Widget>[
          Image.network(_url,
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.hue,
            color: Colors.black,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.white.withOpacity(0.2),
                    Colors.black.withOpacity(0.2),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                )),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Text(
              'Edit Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ]),
      ),
      GestureDetector(
        onTap: onBottomPartTap,
        onVerticalDragUpdate: _handleVerticalUpdate,
        onVerticalDragEnd: _handleVerticalEnd,
        child: FractionallySizedBox(
          heightFactor: 1.05 - _heightFactorAnimation.value,
          alignment: Alignment.bottomCenter,
          child: Container(
            height: _heightFactorAnimation.value,
            decoration: BoxDecoration(
              color: Color(0xFFEEEEEE),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ProfilePageView(_pressSubmit),
            ),
          ),
        ),
      ),
    ]);
  }


  _handleVerticalUpdate(DragUpdateDetails updateDetails) {
    print("update ${updateDetails.primaryDelta}");
    double fractionDragged = updateDetails.primaryDelta / screenheight;
    _controller.value = _controller.value - (5 * fractionDragged);
  }

  _handleVerticalEnd(DragEndDetails endDetails) {
    if (_controller.value >= 0.5) {
      _controller.fling(velocity: 1);
    } else
      _controller.fling(velocity: -1);
  }


  @override
  Widget build(BuildContext context) {
    screenheight = MediaQuery
        .of(context)
        .size
        .height;


    return Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
//        bottomNavigationBar: BottomAppBar(
//          child: Container(
//            decoration: BoxDecoration(
//              color: Colors.white,
//              borderRadius: BorderRadius.only(
//                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
//            ),
//            padding: const EdgeInsets.only(
//              bottom: 32,
//              top: 24,
//              left: 24,
//              right: 24,
//            ),
//            child: Row(
//              mainAxisSize: MainAxisSize.max,
//              mainAxisAlignment: MainAxisAlignment.spaceAround,
//              children: <Widget>[
//                RaisedButton(
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(18.0),
//                      side: BorderSide(color: Colors.teal)),
//                  onPressed: () => ProfilePageView(_pressSubmit),
//                  color: Colors.teal,
//                  textColor: Colors.white,
//                  child: Text("Edit",
//                      style: TextStyle(fontSize: 10)),
//                ),
//              ],
//            ),
//          ),
//        ),
        body: AnimatedBuilder(
          animation: _controller,
          builder: (context, widget) {
            return getWidget();
          },
        ));
  }


}


//class OverlayExample extends StatelessWidget {
//  showOverlay(BuildContext context) async {
//    OverlayState overlayState = Overlay.of(context);
//    OverlayEntry overlayEntry = OverlayEntry(
//        builder: (context) => Positioned(
//          top: 40.0,
//          right: 10.0,
//          child: CircleAvatar(
//            radius: 10.0,
//            backgroundColor: Colors.red,
//            child: Text("1"),
//          ),
//        ));

// OverlayEntry overlayEntry = OverlayEntry(
//         builder: (context) => Positioned(
//               top: MediaQuery.of(context).size.height / 2.0,
//               width: MediaQuery.of(context).size.width / 2.0,
//               child: CircleAvatar(
//                 radius: 50.0,
//                 backgroundColor: Colors.red,
//                 child: Text("1"),
//               ),
//             ));
//    overlayState.insert(overlayEntry);
//
//    await Future.delayed(Duration(seconds: 2));
//
//    overlayEntry.remove();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Overlay Example"),
//        actions: <Widget>[
//          Padding(
//            padding: const EdgeInsets.all(16.0),
//            child: Icon(Icons.notifications),
//          )
//        ],
//      ),
//      body: Center(
//        child: RaisedButton(
//          onPressed: () {
//            showOverlay(context);
//          },
//          child: Text(
//            "Show My Icon",
//            style: TextStyle(color: Colors.white),
//          ),
//          color: Colors.green,
//        ),
//      ),
//    );
//  }
//}
//
//

//showOverlay(BuildContext context) async {
//    OverlayState overlayState = Overlay.of(context);
//    OverlayEntry overlayEntry = OverlayEntry(
//        builder: (context) => Positioned(
//          top: 20,
//          child: ProfilePageView(_pressSubmit),
//        ));
//
//      overlayState.insert(overlayEntry);

//    await Future.delayed(Duration(seconds: 2));

//    overlayEntry.remove();
//  }
