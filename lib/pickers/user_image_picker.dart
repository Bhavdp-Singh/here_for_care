import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);
  final  void Function(File pickedImage) imagePickFn;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  void _pickImage() async {
    final _pickedImageFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
//        imageQuality: 70,
      maxWidth: 150,
    );
    setState(() {
      _pickedImage= _pickedImageFile;
    });
    widget.imagePickFn(_pickedImageFile);
  }


  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
      CircleAvatar(radius: 40,
      backgroundColor: Colors.grey,
      child: _pickedImage != null ? null : Icon(Icons.perm_identity),
      backgroundImage: _pickedImage != null ?  FileImage(_pickedImage) : null,
      ),
    FlatButton.icon(onPressed: _pickImage,
    textColor: Theme.of(context).primaryColor,
    icon: Icon(Icons.image),
    label: Text('Add image')),
    ]);
  }
}
