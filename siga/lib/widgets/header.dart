import 'package:flutter/material.dart';

AppBar header(context,
    {bool isAppTitle = false,
    required String titleText,
    removeBackButton = false}) {
  return AppBar(
    automaticallyImplyLeading: removeBackButton,
    title: Text(
      isAppTitle ? "Siga" : titleText,
      style: TextStyle(
        color: Colors.black,
        fontSize: isAppTitle ? 50 : 20,
      ),
    ),
    centerTitle: true,
    backgroundColor: Colors.white,
  );
}
