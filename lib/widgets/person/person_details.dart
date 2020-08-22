import 'dart:io';
import 'package:flutter/material.dart';
import 'package:here_for_care/pickers/user_image_picker.dart';
import 'package:here_for_care/screens/auth_screen.dart';
import 'package:here_for_care/screens/confirmation_screen.dart';
import 'package:flutter/services.dart';



class PersonDetails extends StatefulWidget with ChangeNotifier{


  final void Function(
      String name,
      String age,
      String phoneNo,
      String address,
      String aadhar,
      File aadharImage,
      BuildContext ctx) submitButton;

PersonDetails(this.submitButton);
  @override
  _PersonDetailsState createState() => _PersonDetailsState();
}


class _PersonDetailsState extends State<PersonDetails> {
  final _nameController = new TextEditingController();
  final _ageController = new TextEditingController();
  final _genderController = new TextEditingController();
  final _addressController = new TextEditingController();
  final _aadharController = new TextEditingController();
  final _phoneController = new TextEditingController();

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
      Navigator.of(context)
          .push(MaterialPageRoute(
        builder: (context) => ConfirmationScreen(name : _name),
      ));
    }
  }


    @override
    Widget build(BuildContext context) {
//      double _width = MediaQuery
//          .of(context)
//          .size
//          .width;
      double _height = MediaQuery
          .of(context)
          .size
          .height;

//      void navigate() {
//        Navigator.of(context).pop('/');
//      }


      void _clearFields() {
        _nameController.clear();
        _ageController.clear();
        _genderController.clear();
        _addressController.clear();
        _aadharController.clear();
        _phoneController.clear();
      }


      return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: SingleChildScrollView(
                child: Container(
                  height: _height,
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: _height / 15),
                          child: Text("Add Details",
                              style: TextStyle(
                                  fontSize: 30.0, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(6.0),
                          child: TextFormField(
                            controller: _nameController,
                            autocorrect: true,
                            decoration: InputDecoration(
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
                            autocorrect: true,
                            textInputAction: TextInputAction.next,
                            controller: _ageController,
                            decoration: InputDecoration(
                              labelText: "Age",
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
                            keyboardType: TextInputType.number,
                            controller: _phoneController,
                            autocorrect: true,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: "Phone no.",
                            ),
                            validator: (value) {
                              if (value.isEmpty || value.length != 10) {
                                return 'Please enter your phone no.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _phone = value;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Row(
                            children: <Widget>[
                              Text('Gender'),
                              SizedBox(
                                width: 20,
                              ),
                              SelectGender(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(6.0),
                          child: TextFormField(
                            controller: _addressController,
                            autocorrect: true,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: "Address",
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
                            decoration: InputDecoration(
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
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(25),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () =>
                                      Navigator.of(context)
                                          .pushNamed(AuthScreen.routeName),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(25),
                                child: InkWell(
                                  onTap: _clearFields,
                                  child: Text(
                                    "Reset",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap:  _trySubmit,
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ));

    }
  }


class SelectGender extends StatefulWidget {
  @override
  _SelectGenderState createState() => _SelectGenderState();
}

class _SelectGenderState extends State<SelectGender> {
  String dropdownValue = 'Male';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(
        color: Colors.black,
      ),
      underline: Container(
        height: 2,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Male', 'Female', 'Others']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Column(
            children: <Widget>[
              Text(value),
//              SizedBox(width: 0.5,),
              Divider(),
            ],
          ),
        );
      }).toList(),
    );
  }
}
