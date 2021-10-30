import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/constant/post_json.dart';
// import 'package:instagram_clone/constant/story_json.dart';
import 'package:instagram_clone/theme/colors.dart';
import 'package:instagram_clone/widgets/story_item.dart';
import 'package:line_icons/line_icons.dart';

import '../widgets/post_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
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
