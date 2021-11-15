import 'package:flutter/material.dart';
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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    // print("Teste 1\n1\n1\n1\n1");
    // Firebase.initializeApp().whenComplete(() {
    //   print("completed");
    //   setState(() {});
    // });
    super.initState();
    getUsers();
  }

  Future<void> getUsers() async {
    // print("Teste 2\n2\n2\n2\n2");
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await usersRef.get();
    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(allData.length);
    print(allData);
    querySnapshot.docs.forEach((DocumentSnapshot element) {
      print(element.data());
      print(element.id);
      print(element.exists);
    });
  }

  // for (int i = 0; i < querySnapshot.docs.length; i++) {
  //   var a = querySnapshot.docs[i];
  //   print(a);
  // }
  // }

  // getUsers() async {
  //   print("Teste 3\n3\n3\n3\n3");
  //   var collection = FirebaseFirestore.instance.collection('users');
  //   var docSnapshot = await collection.get();
  //   if (docSnapshot.size > 0) {
  //     Map<String, dynamic>? data = docSnapshot.data();
  //     var value = data?['username']; // <-- The value you want to retrieve.
  //     // Call setState if needed.
  //   }

  //   usersRef.get().then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       print(doc.data);
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // print("Teste 4\n4\n4\n4\n4");
    return getBody();
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     children: <Widget>[
          //       Padding(
          //           padding: const EdgeInsets.only(
          //               right: 20, left: 15, bottom: 0, top: 10),
          //           child: Column(children: <Widget>[
          //             Row(
          //                 children: List.generate(stories.length, (index) {
          //               return StoryItem(
          //                 img: stories[index]['img'],
          //                 name: stories[index]['name'],
          //               );
          //             }))
          //           ]))
          //     ],
          //   ),
          // ),
          // Divider(
          //   color: black.withOpacity(0.3),
          // ),
          Container(
            height: 200.0,
            color: Colors.white,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 8.0,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: home_cards.length,
              itemBuilder: (BuildContext context, int index) {
                // final Home_card story = home_cards[index - 1];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Home_card(
                    profile_img: home_cards[index]['profile_img'],
                    profile_name: home_cards[index]['profile_name'],
                    event_img: home_cards[index]['event_img'],
                    event_name: home_cards[index]['event_name'],
                  ),
                );
              },
            ),
          ),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     children: <Widget>[
          //       Padding(
          //           padding: const EdgeInsets.only(
          //               right: 20, left: 15, bottom: 0, top: 10),
          //           child: Column(children: <Widget>[
          //             Row(
          //                 children: List.generate(home_cards.length, (index) {
          //               return Home_card(
          //                 profile_img: home_cards[index]['profile_img'],
          //                 profile_name: home_cards[index]['profile_name'],
          //                 event_img: home_cards[index]['event_img'],
          //                 event_name: home_cards[index]['event_name'],
          //               );
          //             }))
          //           ]))
          //     ],
          //   ),
          // ),
          Divider(
            color: black.withOpacity(0.3),
          ),
          Column(
            children: List.generate(posts.length, (index) {
              return PostItem(
                postImg: posts[index]['postImg'],
                profileImg: posts[index]['profileImg'],
                name: posts[index]['name'],
                caption: posts[index]['caption'],
                isLoved: posts[index]['isLoved'],
                viewCount: posts[index]['commentCount'],
                likedBy: posts[index]['likedBy'],
                dayAgo: posts[index]['timeAgo'],
              );
            }),
          )
        ],
      ),
    );
  }
}
