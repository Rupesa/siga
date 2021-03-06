// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:siga/pages/root_app.dart';
import 'package:siga/widgets/home_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import '../theme/colors.dart';
import '../widgets/post_item.dart';
import '../widgets/story_item.dart';
import '../constant/post_json.dart';
import '../constant/story_json.dart';
import '../constant/home_card_json.dart';

CollectionReference usersRef = FirebaseFirestore.instance.collection("users");
CollectionReference postsRef = FirebaseFirestore.instance.collection("posts");

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<dynamic> users = [];
  //final String currentUserId = currentUser?.id;
  bool isLoading = false;
  List<PostItem> posts = [];

  void initState() {
    super.initState();
    getProfilePosts();
  }

  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postsRef
        .doc("asrgw234fsdvwerb4")
        .collection("userPosts")
        .orderBy('timestamp', descending: true)
        .get();

    print("Heyyy");
    print("Heyy");
    print("Hey");
    print(snapshot);
    setState(() {
      isLoading = false;
      print("Heyyy3");
      print("Heyy");
      print("Hey");
      posts = snapshot.docs.map((doc) => PostItem.fromDocument(doc)).toList();
      print(snapshot.docs);
    });
  }

  buildProfilePosts() {
    if (isLoading) {
      return CircularProgressIndicator();
    }
    print("Heyyy2");
    print("Heyy");
    print("Hey");
    return Column(
      children: posts,
    );
  }

  Future<void> getUsers() async {
    // print("Teste 2\n2\n2\n2\n2");
    QuerySnapshot querySnapshot =
        await usersRef.orderBy("postsCount", descending: true).limit(99).get();

    setState(() {
      users = querySnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("Teste 4\n4\n4\n4\n4");
    return getBody();
  }

  Widget getBody() {
    return RefreshIndicator(
        onRefresh: () => getProfilePosts(),
        child: SingleChildScrollView(
          child: buildProfilePosts(),
        ));
  }
}
