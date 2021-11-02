// Stateful Widgets: The widgets whose state can be altered once they are built
// are called stateful Widgets. These states are mutable and can be changed
// multiple times in their lifetime. This simply means the state of an app
// can change multiple times with different sets of variables, inputs, data.

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'search_page.dart';
import 'home_page.dart';
import '../theme/colors.dart';
import 'home_page.dart';
import 'search_page.dart';

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: getBody(),
      appBar: getAppBar(),
      bottomNavigationBar: getFooter(),
    );
  }

  Widget getBody() {
    List<Widget> pages = [
      HomePage(),
      SearchPage(),
      Center(
        child: Text(
          "Camera Page",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: black),
        ),
      ),
      Center(
        child: Text(
          "Activity Page",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: black),
        ),
      ),
      Center(
        child: Text(
          "Account Page",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: black),
        ),
      ),
      Center(
        child: Text(
          "Message Page",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: black),
        ),
      )
    ];
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  PreferredSizeWidget? getAppBar() {
    if (pageIndex == 0) {
      return AppBar(
        backgroundColor: white,
        title: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              " Siga",
              style: TextStyle(fontSize: 35, wordSpacing: 4, color: black),
            ),
            //SizedBox(width: 200),
            Spacer(),
            Material(
              child: InkWell(
                onTap: () {
                  selectedTab(5);
                },
                child: ClipRRect(
                  child: Image(
                      image: AssetImage("assets/images/message.png"),
                      width: 30),
                ),
              ),
            ),
            // Image(image: AssetImage("assets/images/message.png"), width: 30),
            SizedBox(width: 10),
          ],
        ),
      );
    } else if (pageIndex == 1) {
      return null;
    } else if (pageIndex == 2) {
      return AppBar(
          backgroundColor: appBarColor,
          title: Text("Camera",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: black)));
    } else if (pageIndex == 3) {
      return AppBar(
          backgroundColor: appBarColor,
          title: Text("Activity",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: black)));
    } else if (pageIndex == 4) {
      return AppBar(
          backgroundColor: appBarColor,
          title: Text("Account",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: black)));
    } else {
      return AppBar(
          backgroundColor: appBarColor,
          title: Text("Message",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: black)));
    }
  }

  Widget getFooter() {
    List bottomItems = [
      pageIndex == 0
          ? "assets/images/home_selected.png"
          : "assets/images/home.png",
      pageIndex == 1
          ? "assets/images/event_selected.png"
          : "assets/images/event.png",
      pageIndex == 2
          ? "assets/images/camera_selected.png"
          : "assets/images/camera.png",
      pageIndex == 3
          ? "assets/images/heart_selected.png"
          : "assets/images/heart.png",
      pageIndex == 4
          ? "assets/images/profile_selected.png"
          : "assets/images/profile.png",
    ];
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(color: white),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(bottomItems.length, (index) {
            return InkWell(
                onTap: () {
                  selectedTab(index);
                },
                child: Image(image: AssetImage(bottomItems[index]), width: 27));
          }),
        ),
      ),
    );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
