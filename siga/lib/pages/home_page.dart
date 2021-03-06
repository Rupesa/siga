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
CollectionReference cardsRef = FirebaseFirestore.instance.collection("cards");

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> users = [];
  //final String currentUserId = currentUser?.id;
  bool isLoading = false;
  List<PostItem> posts = [];
  List<Home_card> cards = [];

  void initState() {
    super.initState();
    getProfilePosts();
    // getCards();
    // createUser();
    // getUserByName("Fred");
    // getUsers();
    // getUserByID("U8Ttlz8Idf6uwR6Db43b");
  }

  getProfilePosts() async {
    getCards();
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postsRef
        .doc("asrgw234fsdvwerb4")
        .collection("userPosts")
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      isLoading = false;
      posts = snapshot.docs.map((doc) => PostItem.fromDocument(doc)).toList();
    });
  }

  getCards() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot2 = await cardsRef.get();
    setState(() {
      isLoading = false;
      cards = snapshot2.docs.map((doc) => Home_card.fromDocument(doc)).toList();
    });
  }

  createUser() {
    usersRef
        .doc("randomID")
        .set({"username": "Robert", "isAdmin": false, "postsCount": 1});
  }

  deleteUser() async {
    final doc = await usersRef.doc("randomID").get();
    if (doc.exists) {
      doc.reference.delete();
    }
  }

  updateUser() async {
    final doc = await usersRef.doc("randomID").get();
    if (doc.exists) {
      doc.reference
          .update({"username": "Robert", "isAdmin": false, "postsCount": 2});
    }
  }

  buildProfilePosts() {
    if (isLoading) {
      return CircularProgressIndicator();
    }
    return Column(
      children: posts,
    );
  }

  buildCards() {
    if (isLoading) {
      return CircularProgressIndicator();
    }
    return Container(
      height: 200.0,
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 8.0,
        ),
        scrollDirection: Axis.horizontal,
        children: cards,
      ),
    );
  }

  Future<void> getUserByID(String userID) async {
    // print("Teste 2\n2\n2\n2\n2");
    DocumentSnapshot<Object?> user_doc = await usersRef.doc(userID).get();
    print(user_doc.data());
    print(user_doc.id);
    print(user_doc.exists);
  }

  Future<void> getUserByName(String userName) async {
    print("Teste 2\n2\n2\n2\n2");
    QuerySnapshot querySnapshot =
        await usersRef.where("username", isEqualTo: userName).get();
    querySnapshot.docs.forEach((DocumentSnapshot element) {
      print(element.data());
      print(element.id);
      print(element.exists);
    });
  }

  Future<void> getUsers() async {
    // print("Teste 2\n2\n2\n2\n2");
    QuerySnapshot querySnapshot =
        await usersRef.orderBy("postsCount", descending: true).limit(99).get();

    setState(() {
      users = querySnapshot.docs;
    });

    // final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    // print(allData.length);
    // print(allData);

    // querySnapshot.docs.forEach((DocumentSnapshot element) {
    //   print(element.data());
    //   print(element.id);
    //   print(element.exists);
    // });
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
          child: Column(
            children: <Widget>[
              // StreamBuilder<QuerySnapshot>(
              //   // always getting data
              //   //FutureBuilder<QuerySnapshot>( // gets data once
              //   // future: usersRef.get(),
              //   stream: usersRef.snapshots(),
              //   builder: (context, snapshot) {
              //     if (!snapshot.hasData) {
              //       return CircularProgressIndicator();
              //     }
              //     final List<Text> children = snapshot.data!.docs
              //         .map((document) => Text(document["username"]))
              //         .toList();
              //     return Container(
              //         height: 200.0, child: ListView(children: children));
              //   },
              // ),

              // Container(
              //   height: 200.0,
              //   child: ListView(
              //     children: users.map((user) => Text(user["username"])).toList(),
              //   ),
              // ),
              buildCards(),
              Divider(
                color: black.withOpacity(0.3),
              ),
              buildProfilePosts(),
              // Column(
              //   children: List.generate(posts.length, (index) {
              //     return PostItem(
              //       postImg: posts[index]['postImg'],
              //       profileImg: posts[index]['profileImg'],
              //       name: posts[index]['name'],
              //       caption: posts[index]['caption'],
              //       isLoved: posts[index]['isLoved'],
              //       dayAgo: posts[index]['timeAgo'],
              //       likeNumber: 0,
              //       ownerId: '',
              //       postId: '',
              //     );
              //   }),
              // )
            ],
          ),
        ));
  }
}
