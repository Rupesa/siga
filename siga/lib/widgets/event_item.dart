import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:siga/pages/login_page.dart';
import 'package:siga/pages/root_app.dart';

import '../theme/colors.dart';

class EventItem extends StatelessWidget {
  final String eventId;
  final String profileImg;
  final String name;
  final String postImg;
  final String ownerId;
  final String caption;
  final String dayAgo;
  final String location;
  final double lat;
  final double lng;

  const EventItem({
    Key? key,
    required this.eventId,
    required this.profileImg,
    required this.name,
    required this.postImg,
    required this.ownerId,
    required this.dayAgo,
    required this.caption,
    required this.location,
    required this.lat,
    required this.lng,
  }) : super(key: key);

  factory EventItem.fromDocument(DocumentSnapshot doc) {
    return EventItem(
      name: doc["username"],
      ownerId: doc["ownerId"],
      postImg: doc["mediaUrl"],
      lat: doc["lat"],
      lng: doc["lng"],
      caption: doc["description"],
      // location: doc["location"],
      location: doc["location"],
      dayAgo: doc["timestamp"].toDate().toString().substring(0, 10),
      eventId: doc["eventId"],
      profileImg: doc["userUrl"],
    );
  }

  vou() {
    cardsRef.doc(eventId).set({
      "eventId": eventId + currentUser!.username,
      "ownerId": currentUser!.id,
      "username": currentUser!.username,
      "eventname": caption,
      "mediaUrl": postImg,
      "userUrl": currentUser!.photoUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(profileImg),
                              fit: BoxFit.cover)),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                          color: black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 235,
                    ),
                    IconButton(
                      onPressed: () => vou(),
                      icon: SizedBox.fromSize(
                        size: Size.fromRadius(200),
                        child: FittedBox(
                          child: Icon(
                            Icons.check_circle_outline,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 400,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(postImg), fit: BoxFit.cover)),
          ),
          SizedBox(
            height: 12,
          ),
          Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "$caption",
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        color: black)),
              ]))),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            child: Text(
              "$location",
              style: TextStyle(
                  color: black, fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            child: Text(
              "$dayAgo",
              style: TextStyle(
                  color: black.withOpacity(0.5),
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}
