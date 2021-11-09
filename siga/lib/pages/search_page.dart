import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../constant/post_json.dart';
import '../constant/search_json.dart';
import '../widgets/search_category_item.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
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
    ));
  }
}
