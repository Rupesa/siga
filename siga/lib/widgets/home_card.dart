import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';

import '../theme/colors.dart';

class Home_card extends StatelessWidget {
  final String profile_img;
  final String profile_name;
  final String event_img;
  final String event_name;

  const Home_card({
    Key? key,
    required this.profile_img,
    required this.profile_name,
    required this.event_img,
    required this.event_name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
              height: double.infinity,
              width: 170.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover, image: AssetImage(event_img)))),
        ),
        Container(
          height: double.infinity,
          width: 170.0,
          decoration: BoxDecoration(
            gradient: storyGradient,
            borderRadius: BorderRadius.circular(12.0),
            // boxShadow: Responsive.isDesktop(context)
            //     ? const [
            //         BoxShadow(
            //           color: Colors.black26,
            //           offset: Offset(0, 2),
            //           blurRadius: 4.0,
            //         ),
            //       ]
            //     : null,
          ),
        ),
        Positioned(
          top: 8.0,
          left: 8.0,
          // ? Container(
          //     height: 40.0,
          //     width: 40.0,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       shape: BoxShape.circle,
          //     ),
          //     child: IconButton(
          //       padding: EdgeInsets.zero,
          //       icon: const Icon(Icons.add),
          //       iconSize: 30.0,
          //       color: Palette.facebookBlue,
          //       onPressed: () => print('Add to Story'),
          //     ),
          //   )
          // : ProfileAvatar(
          child: Column(
            children: <Widget>[
              Container(
                width: 68,
                height: 68,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                        border: Border.all(color: white, width: 2),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                              profile_img,
                            ),
                            fit: BoxFit.cover)),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                width: 70,
                child: Text(
                  profile_name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: white, fontSize: 11),
                ),
              ),
              SizedBox(
                width: 70,
                child: Text(
                  "vai",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: white,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          bottom: 8.0,
          left: 8.0,
          right: 8.0,
          child: Text(
            event_name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
