import 'dart:async';
import 'dart:io';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:image_picker/image_picker.dart';
import 'package:siga/model/user.dart';
import 'package:siga/theme/colors.dart';

import 'login_page.dart';

class CameraPage extends StatefulWidget {
  late final User? currentUser;

  CameraPage({this.currentUser});

  @override
  State<StatefulWidget> createState() {
    return _CameraPageSate();
  }
}

class _CameraPageSate extends State<CameraPage> {
  File? file1;
  final ImagePicker _picker = ImagePicker();

  Future handleTakePhoto() async {
    XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );

    setState(() {
      file1 = File(file!.path);
    });
  }

  Future handleChooseGallery() async {
    //final ImagePicker _picker = ImagePicker();

    XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 675,
      maxWidth: 960,
    );

    setState(() {
      file1 = File(file!.path);
    });
  }

  selectImage(parentContect) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create Post"),
            children: <Widget>[
              SimpleDialogOption(
                  child: const Text("Photo with Camera"),
                  onPressed: () {
                    Future.delayed(Duration.zero, () {
                      handleTakePhoto();
                      Navigator.pop(context);
                    });
                  }),
              SimpleDialogOption(
                  child: const Text("Photo from Gallery"),
                  onPressed: () {
                    Future.delayed(Duration.zero, () {
                      handleChooseGallery();
                      Navigator.pop(context);
                    });
                  }),
              SimpleDialogOption(
                child: const Text("Cancel"),
                onPressed: () => Future.delayed(Duration.zero, () {
                  Navigator.pop(context);
                }),
              ),
            ],
          );
        });
  }

  Container buildSplashScreen() {
    return Container(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/images/upload.svg', height: 260.0),
            Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  child: Text(
                    "Upload Image",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepOrange, // background
                  ),
                  onPressed: () => selectImage(context),
                ))
          ],
        ));
  }

  clearImage() {
    setState(() {
      file1 = null;
    });
  }

  buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: clearImage,
        ),
        title: const Text(
          "Caption Post",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
              onPressed: () => print('pressed'),
              child: Text("Post",
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0)))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return file1 == null ? buildSplashScreen() : buildUploadForm();
  }
}
