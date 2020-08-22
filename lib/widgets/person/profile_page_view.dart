import 'package:flutter/material.dart';
import 'package:here_for_care/pickers/user_image_picker.dart';
import 'dart:io';
import 'package:here_for_care/screens/go_to_bot.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProfilePageView extends StatefulWidget {



  final void Function(
      String name,
      String age,
      String phoneNo,
      String address,
      String aadhar,
      File aadharImage,
      BuildContext ctx) submitButton;

  ProfilePageView(this.submitButton);
  @override
  _ProfilePageViewState createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {

//  var isInit = false;
//  @override
//  void didChangeDependencies() {
//    if(isInit){
//      final personId = Provider.of<AuthScreen>(context).
//    }
//    isInit =false;
//    super.didChangeDependencies();
//  }

  bool isLoading = false;

  String _pname ="";
  String  _page="";
  String _paddress ="";
  String _paadhar ="";
  String _purl = "";


  getPDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _pname = prefs.getString('name');
      _page = prefs.getString('age');
      _paddress = prefs.getString('address');
      _paadhar = prefs.getString('aadhar');
      _purl = prefs.getString('_url');
      isLoading = true;
    });
    print('gettings details of user $_purl');
  }

  final _nameController = new TextEditingController();
  final _ageController = new TextEditingController();
  final _addressController = new TextEditingController();
  final _aadharController = new TextEditingController();
//  final _phoneController = new TextEditingController();
  var _name = '';
  var _age = '';
  var _phone = '';
  var _address = '';
  var _aadhar = '';
  File _userAadharImage;
  final _formKey = GlobalKey<FormState>();

  void _pickedImage(File image) {
    _userAadharImage = image;
  }

  void _trySubmit() {
    final _isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (_userAadharImage == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please click your aadhar image. '),
      ));
      return;
    }
    if (_isValid) {
      _formKey.currentState.save();
      widget.submitButton(
        _name.trim(),
        _age.trim(),
        _phone.trim(),
        _address.trim(),
        _aadhar.trim(),
        _userAadharImage,
        context,
      );
    }
    Navigator.of(context).pushReplacementNamed(GoToBot.routeName);
  }

  @override
  void initState() {
    getPDetails();
    super.initState();
  }


    @override
    Widget build(BuildContext context) {

      return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                children: <Widget>[Padding(
          padding: EdgeInsets.all(15.0),
          child: TextFormField(
            controller: _nameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: _pname,
                labelText: "Name",
            ),
            validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
            },
            onSaved: (value) {
                _name = value;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(6.0),
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: _ageController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                labelText: "Age",
              hintText: _page,
            ),
            validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your age';
                }
                return null;
            },
            onSaved: (value) {
                _age = value;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(6.0),
          child: TextFormField(
            controller: _addressController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                labelText: "Address",
              hintText: _paddress,
            ),
            validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your address';
                }
                return null;
            },
            onSaved: (value) {
                _address = value;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(6.0),
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: _aadharController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: _paadhar,
                labelText: "Aadhar  number",
            ),
            validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your 12 digit aadhar no.';
                }
                return null;
            },

            onSaved: (value) {
                _aadhar = value;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(6.0),
          child: Column(
            children: <Widget>[
                Text('Click Aadhar Card'),
                SizedBox(
                  height: 15,
                ),
                UserImagePicker(_pickedImage),
            ],
          ),
        ),
        SizedBox(width: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
//            RaisedButton(
//                shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(18.0),
//                    side: BorderSide(color: Colors.teal)),
//                onPressed: () {},
//                color: Colors.teal,
//                textColor: Colors.white,
//                child: Text("Edit",
//                    style: TextStyle(fontSize: 15)),
//            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.teal)),
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.teal,
              textColor: Colors.white,
              child: Text("Cancel",
                  style: TextStyle(fontSize: 15)),

            ),
            RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.teal)),
                onPressed: _trySubmit,
                color: Colors.teal,
                textColor: Colors.white,
                child: Text("Save",
                    style: TextStyle(fontSize: 15)),

            ),
          ],
        ),


        ],),
              )],
          ),
        ),


      );

    }
  }

