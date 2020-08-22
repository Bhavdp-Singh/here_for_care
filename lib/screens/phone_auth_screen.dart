import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:here_for_care/screens/person_details_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  PhoneAuthScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo,
          // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent: smsOTPSent,
          // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(title: Text('Verification Code'),),
            body: Container(
              height: 400,
              decoration: BoxDecoration(
//                boxShadow: BoxShadow(color: Colors.black54),
                borderRadius: BorderRadius.circular(10),
                ),        
              child: Padding(
                padding: EdgeInsets.all(15),

              child: new Card(
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text('We have sent an SMS with an activation code to  +91 $phoneNo',
                        textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'LexendGiga',
                       fontSize: 12,
                      ),),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Please enter activation code manually',
                         textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'LexendGiga',
                          fontSize: 12,
                          color: Colors.black38,
                        ),),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: TextField(
                        autofocus: true,
                        onChanged: (value) {
                          this.smsOTP = value;
                        },
                      ),
                    ),
                    (errorMessage != ''
                        ? Text(
                            errorMessage,
                            style: TextStyle(color: Colors.red),
                          )
                        : Container()),
                FlatButton(
                    child: Text('Done'),
                    onPressed: () {
                      _auth.currentUser().then((user) {
                        if (user != null) {
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .pushNamed(PersonDetailsScreen.routeName);
                        } else {
                          signIn();
                        }
                      });
                    },
                  ),
              ]),
            ),
          ),
          ));
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)) as FirebaseUser;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      Navigator.of(context).pushReplacementNamed(PersonDetailsScreen.routeName);
    } catch (e) {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 250,
          child: Card(
            elevation: 10.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'We will send an Sms with a confirmation code to this number ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontFamily: 'LexendGiga', fontSize:15),
                    decoration: InputDecoration(
                      hintText: '  Enter Phone Number Eg.',
                    ),
                    onChanged: (value) {
                      this.phoneNo = value;
                    },
                  ),
                ),
                (errorMessage != ''
                    ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container()),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () {
                    verifyPhone();
                  },
                  child: Text('Verify'),
                  textColor: ThemeData().primaryColor,
                  elevation: 7,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
} //import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:here_for_care/screens/person_details_screen.dart';
//import 'package:here_for_care/services/authservice.dart';
//import 'package:flutter/services.dart';
//
//class Phone_Auth_Screen extends StatefulWidget {
//  @override
//  _Phone_Auth_ScreenState createState() => _Phone_Auth_ScreenState();
//}
//
//class _Phone_Auth_ScreenState extends State<Phone_Auth_Screen> {
//  final formKey = new GlobalKey<FormState>();
//
//  String phoneNo, verificationId, smsOTP;
//  String errorMessage = '';
//  bool codeSent = false;
//  FirebaseAuth _auth = FirebaseAuth.instance;
//
//  Future<void> verifyPhone() async {
//    final PhoneCodeSent smsOTPSent = (String verId, [intForceCodeResend]) {
//      this.verificationId = verId;
//      smsOTPDialog(context).then((value) {
//        print('Signed In');
//      });
//    };
//    try {
//      await _auth.verifyPhoneNumber(
//          phoneNumber: this.phoneNo,
//          timeout: const Duration(seconds: 30),
//          verificationCompleted: (AuthCredential _phoneAuthCredential) {
//            print(_phoneAuthCredential);
//          }
//          ,
//          verificationFailed: (AuthException exception) {
//            print('${exception.message}');
//          },
//          codeSent: smsOTPSent,
//          codeAutoRetrievalTimeout: (String verId) {
//            this.verificationId = verId;
//          });
//    } catch (e) {
//      handleError(e);
//    }
//
//    final PhoneVerificationFailed verificationFailed =
//        (AuthException authException) {
//      print('${authException.message}');
//    };
//
//    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
//      this.verificationId = verId;
//      setState(() {
//        this.codeSent = true;
//      });
//    };
//
//    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
//      this.verificationId = verId;
//    };
//
//
//    Future<bool> smsOTPDialog(BuildContext context) {
//      return showDialog(
//          context: context,
//          barrierDismissible: false,
//          builder: (BuildContext context) {
//            return Card(
//              elevation: 10,
//              child: new AlertDialog(
//                title: Text('Enter otp manually'),
//                content: Container(
//                  child: Column(
//                    children: <Widget>[
//                      TextField(
//                        autofocus: true,
//                        onChanged: (value) {
//                          this.smsOTP = value;
//                        },
//                      ),
//                      (errorMessage != '' ? Text(errorMessage,
//                        style: TextStyle(
//                          color: Colors.red,
//                        ),
//                      ) : Container()),
//                    ],
//                  ),
//                ),
//                contentPadding: EdgeInsets.all(10.0),
//                actions: <Widget>[
//                  new FlatButton(
//                    child: Text('Done'),
//                    onPressed: () {
//                      _auth.currentUser().then((user) {
//                        if (user != null) {
//                          Navigator.of(context).pop();
//                          Navigator.of(context).pushReplacementNamed(
//                              PersonDetailsScreen.routeName);
//                        }
//                        else {
//                          Navigator.of(context).pop();
//                          signIn();
//                        }
//                      });
//                    },)
//                ],
//              ),
//            );
//          }
//      );
//    }
//
//    signIn() async {
//      try {
//        AuthCredential credential = PhoneAuthProvider.getCredential(
//            verificationId: verificationId, smsCode: smsOTP);
//        final FirebaseUser user = await _auth.signInWithCredential(credential);
//        final FirebaseUser currentUser = await _auth.currentUser();
//        assert(user.uid == currentUser.uid);
//        Navigator.of(context).pop();
//        Navigator.of(context).pushReplacementNamed(
//            PersonDetailsScreen.routeName);
//      }catch(e){
//        handleError(e);
//      }
//    }
//
//
//
//  }
//}
//
//
//
//handleError(PlatformException error) {
//    print(error);
//    switch (error.code) {
//      case 'ERROR_INVALID_VERIFICATION_CODE':
//        FocusScope.of(context).requestFocus(new FocusNode());
//        setState(() {
//          errorMessage = 'Invalid Code';
//        });
//        Navigator.of(context).pop();
//        smsOTPDialog(context).then((value) {
//          print('sign in');
//        });
//        break;
//      default:
//        setState(() {
//          errorMessage = error.message;
//        });
//
//        break;
//    }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Login'),
//      ),
//      body: Padding(
//        padding: const EdgeInsets.all(8.0),
//        child: Container(
//          height: 300,
//          child: Card(
//            elevation: 10,
//            child: Form(
//                key: formKey,
//                child: Column(
//                  children: <Widget>[
//
//                    Padding(
//                      padding: const EdgeInsets.all(20),
//                      child: Text(
//                        'We will send an SMS with a confirmation code to this number.',
//                        style: TextStyle(
//                          fontSize: 15,
//                          fontWeight: FontWeight.w300,
//                          fontFamily: 'Raleway',
//                        ),),
//                    ),
//                    Padding(
//                        padding: EdgeInsets.only(
//                            left: 25.0, right: 25.0, top: 25),
//                        child: TextFormField(
//                          keyboardType: TextInputType.phone,
//                          decoration: InputDecoration(
//                              hintText: 'Enter phone number'),
//                          onChanged: (val) {
//                            setState(() {
//                              this.phoneNo = val;
//                            });
//                          },
//                        )),
//                    codeSent ? Padding(
//                        padding: EdgeInsets.only(left: 25.0, right: 25.0),
//                        child: TextFormField(
//                          keyboardType: TextInputType.phone,
//                          decoration: InputDecoration(hintText: 'Enter OTP'),
//                          onChanged: (val) {
//                            setState(() {
//                              this.smsOTP = val;
//                            });
//                          },
//                        )) : Container(),
//                    Padding(
//                        padding: EdgeInsets.only(left: 25.0, right: 25.0),
//                        child: RaisedButton(
//                            child: Center(
//                                child: codeSent ? Text('Login') : Text(
//                                    'Verify')),
//                            onPressed: () {
//                              codeSent ? AuthService().signInWithOTP(
//                                  smsOTP, verificationId) : verifyPhone(
//                                  phoneNo);
//                            }))
//                  ],
//                )),
//          ),
//        ),
//      ),
//    );
//  }
//
