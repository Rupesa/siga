import 'dart:async';

import 'dart:io';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:siga/model/user.dart';
import 'package:siga/pages/login_page.dart';
import 'package:siga/pages/root_app.dart';
import 'package:siga/theme/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:siga/utils/user_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:geocoding/geocoding.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../theme/colors.dart';
import '../constant/post_json.dart';
import '../constant/search_json.dart';
import '../widgets/search_category_item.dart';

import 'package:geolocator/geolocator.dart';
import 'login_page.dart';

class SearchPage extends StatefulWidget {
  late final User? currentUser;

  SearchPage({this.currentUser});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  File? file1;
  final ImagePicker _picker = ImagePicker();
  bool isUploading = false;
  bool addEvent = false;
  String? place_id;
  double? lat, lng;

  String eventId = Uuid().v4();
  String _sessionToken = Uuid().v4();
  TextEditingController _controller = TextEditingController();
  TextEditingController captionController = TextEditingController();
  List<dynamic> _placeList = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged();
    });
  }

  _onChanged() {
    print(
        "--------------------------------------------------------------------------------------");
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = Uuid().v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    print("getSugges");
    String API_KEY = "AIzaSyCKffUTFXNQNQ22vI-ggF2EWnbFVXEf1_k";

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$API_KEY';
    var response = await http.get(Uri.parse(request));
    //print(response);
    if (response.statusCode == 200) {
      setState(() {
        print(response.body);
        _placeList = jsonDecode(response.body)['predictions'];
        print(_placeList.length);
      });
    } else {
      print(
          "...................................................................");
      throw Exception('Failed to load predictions');
    }
  }

  clearImage() {
    setState(() {
      file1 = null;
      addEvent = false;
    });
  }

  Future<String> uploadImage(imageFile) async {
    String eventId = Uuid().v4();
    firebase_storage.UploadTask uploadTask =
        ref.child("post_$eventId.jpg").putFile(imageFile);

    firebase_storage.TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();

    return downloadUrl;
  }

  createEventInFirebase(
      {String? mediaUrl, double? lat, double? lng, String? description}) {
    String eventId = Uuid().v4();
    eventsRef.doc(eventId).set({
      "eventId": eventId,
      "ownerId": widget.currentUser!.id,
      "username": widget.currentUser!.username,
      "mediaUrl": mediaUrl,
      "description": description,
      "lat": lat,
      "lng": lng,
      "timestamp": timestamp,
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
    createEventInFirebase(
      mediaUrl: mediaUrl,
      lat: lat,
      lng: lng,
      description: captionController.text,
    );
    print("hey2");
    captionController.clear();
    _controller.clear();

    setState(() {
      print("hey3");
      file1 = null;
      isUploading = false;
    });
  }

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

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    String eventId = Uuid().v4();

    Im.Image? imageFile = Im.decodeImage(file1!.readAsBytesSync());

    final compressedImageFile = File('$path/img_$eventId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile!, quality: 85));
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

  @override
  Widget build(BuildContext context) {
    return addEvent ? buildUploadForm() : getPage();
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
          "Add an Event",
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
              onPressed: () => isUploading ? null : {handleSubmit()},
              child: Text("Add",
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
          _displayMedia(file1),
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          Container(
            width: 400.0,
            alignment: Alignment.center,
            child: ElevatedButton.icon(
              style: ButtonStyle(alignment: Alignment.center),
              onPressed: () => selectImage(context),
              icon: Icon(Icons.add_a_photo, color: Colors.orange),
              label: Text(
                "Add event photo",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading: Icon(
              Icons.pin_drop,
              color: Colors.orange,
              size: 35.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                // onTap: () => setState(() {}),
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Where is the event?",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _placeList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => {
                    print(index),
                    place_id = _placeList[index]["place_id"],
                    _controller.text = _placeList[index]["description"],
                    _getCoordinates(),
                    setState(() {
                      _placeList.clear();
                    })
                  },
                  title: Text(_placeList[index]["description"]),
                );
              }),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.description,
              color: Colors.orange,
              size: 35.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                  controller: captionController,
                  decoration: InputDecoration(
                    hintText: "Write a description of the event...",
                    border: InputBorder.none,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  _getCoordinates() async {
    String request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$place_id&key=AIzaSyCKffUTFXNQNQ22vI-ggF2EWnbFVXEf1_k';

    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        print("=======================================================");
        print(place_id);
        print(response.body);

        var resultCoord = jsonDecode(response.body)['result'];

        print(resultCoord["geometry"]["location"]["lat"]);
        print(resultCoord["geometry"]["location"]["lng"]);

        lat = resultCoord["geometry"]["location"]["lat"];
        lng = resultCoord["geometry"]["location"]["lng"];
      });
      //     _placeList = jsonDecode(response.body)['predictions'];
      //     print(_placeList.length);
      //   });
    } else {
      print("+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
      throw Exception('Failed to load coordinates');
    }
  }

  addEvents() {
    setState(() {
      addEvent = true;
    });
  }

  Widget _displayMedia(File? media) {
    print(media);
    if (media == null) {
      return Container(
        height: 220.0,
        //width: MediaQuery.of(context).size.width * 0.8,
        child: Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                //image: DecorationImage(
                //fit: BoxFit.cover, image: FileImage(file1!)),
                color: Colors.grey,
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: 220.0,
        //width: MediaQuery.of(context).size.width * 0.8,
        child: Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: FileImage(file1!)),
                color: Colors.grey,
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget getPage() {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: appBarColor,
          toolbarHeight: 70,
          elevation: 0,
          title: Text(
            "Events",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: black),
          ),
          actions: [
            IconButton(
              onPressed: () => addEvents(),
              icon: SizedBox.fromSize(
                size: Size.fromRadius(200),
                child: FittedBox(
                  child: Icon(
                    Icons.add,
                    color: black,
                  ),
                ),
              ),
            )
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SafeArea(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: size.width - 30,
                    height: 45,
                    // child: TextField(
                    //   decoration: InputDecoration(
                    //     hintText: "Search...",
                    //     hintStyle: TextStyle(color: Colors.grey.shade600),
                    //     prefixIcon: Icon(
                    //       Icons.search,
                    //       color: Colors.grey.shade600,
                    //       size: 20,
                    //     ),
                    //     filled: true,
                    //     fillColor: Colors.grey.shade100,
                    //     contentPadding: EdgeInsets.all(8),
                    //     enabledBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(20),
                    //         borderSide: BorderSide(color: Colors.grey.shade100)),
                    //   ),
                    // ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Search...",
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade600,
                          )),
                      style: TextStyle(color: white.withOpacity(0.3)),
                      cursorColor: white.withOpacity(0.3),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                    children: List.generate(searchCategories.length, (index) {
                  return CategoryStoryItem(
                    name: searchCategories[index],
                  );
                })),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Wrap(
              spacing: 1,
              runSpacing: 1,
              children: List.generate(searchImages.length, (index) {
                return Container(
                  width: (size.width - 3) / 3,
                  height: (size.width - 3) / 3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(searchImages[index]),
                          fit: BoxFit.cover)),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
