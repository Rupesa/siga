// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:siga/src/widgets.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  late String username;

  submit() {
    _formKey.currentState!.save();
    Navigator.pop(context, username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: header("Set up your profile"),
        body: ListView(
      children: [
        Container(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: Center(
                child: Text(
                  "Create a username",
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    onSaved: (val) => username = val!,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Username",
                      labelStyle: TextStyle(fontSize: 15),
                      hintText: "Must be at least 3 characters",
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
                onTap: () => submit(),
                child: Container(
                  height: 50,
                  width: 350,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(7.0)),
                  child: Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ))
          ],
        ))
      ],
    ));
  }
}