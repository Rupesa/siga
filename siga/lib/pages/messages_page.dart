import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';
import '../pages/edit_profile_page.dart';
import '../utils/user_preferences.dart';
// import '../widgets/appbar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/numbers_widget.dart';
import '../widgets/profile_widget.dart';
import '../constant/messages_json.dart';
import '../widgets/massages_list.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Widget getBody() {
    final user = UserPreferences.myUser;

    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: chatUsers.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 16),
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return MessageList(
            name: chatUsers[index].name,
            messageText: chatUsers[index].messageText,
            imageUrl: chatUsers[index].imageURL,
            time: chatUsers[index].time,
            isMessageRead: (index == 0 || index == 3) ? true : false,
          );
        },
      ),
    );
  }
}
