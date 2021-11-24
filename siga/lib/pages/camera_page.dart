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
import 'package:siga/pages/root_app.dart';
import 'package:siga/theme/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:geocoding/geocoding.dart';

import 'package:geolocator/geolocator.dart';
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
  bool isUploading = false;
  String postId = Uuid().v4();
  TextEditingController locationController = TextEditingController();
  TextEditingController captionController = TextEditingController();

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

  selectImage(parentContext) {
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

  Future<String> uploadImage(imageFile) async {
    String postId = Uuid().v4();
    firebase_storage.UploadTask uploadTask =
        ref.child("post_$postId.jpg").putFile(imageFile);

    firebase_storage.TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();

    return downloadUrl;
  }

  createPostInFirebase(
      {String? mediaUrl, String? location, String? description}) {
    String postId = Uuid().v4();
    postsRef.doc("asrgw234fsdvwerb4").collection("userPosts").doc(postId).set({
      "postId": postId,
      "ownerId": widget.currentUser!.id,
      "username": widget.currentUser!.username,
      "mediaUrl": mediaUrl,
      "description": description,
      "location": location,
      "timestamp": timestamp,
      "userUrl": widget.currentUser!.photoUrl,
    });
  }

  handleSubmit() async {
    print("handleSubmit");
    setState(() {
      print("setState");
      isUploading = true;
    });
    await compressImage();
    print("hey1");
    String mediaUrl = await uploadImage(file1);
    createPostInFirebase(
      mediaUrl: mediaUrl,
      location: locationController.text,
      description: captionController.text,
    );
    print("hey2");
    captionController.clear();
    locationController.clear();

    setState(() {
      print("hey3");
      file1 = null;
      isUploading = false;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    String postId = Uuid().v4();

    Im.Image? imageFile = Im.decodeImage(file1!.readAsBytesSync());

    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile!, quality: 85));
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
                onPressed: () => isUploading ? null : {handleSubmit()},
                child: Text("Post",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0)))
          ],
        ),
        body: ListView(
          children: <Widget>[
            isUploading ? LinearProgressIndicator() : Text(""),
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            Container(
              //height: 220.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover, image: FileImage(file1!)),
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(widget.currentUser!.photoUrl),
              ),
              title: Container(
                width: 250.0,
                child: TextField(
                    controller: captionController,
                    decoration: InputDecoration(
                      hintText: "Write a caption...",
                      border: InputBorder.none,
                    )),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.pin_drop,
                color: Colors.orange,
                size: 35.0,
              ),
              title: Container(
                width: 250.0,
                child: TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    hintText: "Where was this photo taken?",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Container(
                width: 200.0,
                height: 100.0,
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                    onPressed: () => getUserLocation(),
                    icon: Icon(
                      Icons.my_location,
                      color: Colors.white,
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red)),
                      ),
                    ),
                    label: Text(
                      "Use Current Location",
                      style: TextStyle(color: Colors.white),
                    )))
          ],
        ));
  }

  getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark placemark = placemarks[0];

    String completeAddress =
        '${placemark.subThoroughfare}${placemark.thoroughfare},${placemark.subLocality}${placemark.locality},${placemark.subAdministrativeArea}, ${placemark.administrativeArea},${placemark.postalCode},  ${placemark.country}';

    print(completeAddress);

    String formattedAddress =
        "${placemark.subLocality}${placemark.locality},${placemark.country}";

    locationController.text = formattedAddress;
  }

  @override
  Widget build(BuildContext context) {
    return file1 == null ? buildSplashScreen() : buildUploadForm();
  }
}
