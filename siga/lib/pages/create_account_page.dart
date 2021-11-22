// import 'dart:html';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:siga/src/widgets.dart';
import 'package:siga/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  late String username;

  submit() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      SnackBar snackBar = SnackBar(content: Text("Welcome $username!"));
      // ignore: deprecated_member_use
      _scaffoldKey.currentState?.showSnackBar(snackBar);
      Timer(const Duration(seconds: 2), () {
        Navigator.pop(context, username);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: header(context, titleText: "Set up your profile", removeBackButton: true),
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
                  autovalidateMode: AutovalidateMode.always,
                  key: _formKey,
                  child: TextFormField(
                    validator: (val) {
                      if (val!.trim().length < 3 || val.isEmpty) {
                        return "Username too short";
                      } else if (val.trim().length > 12) {
                        return "Username too long";
                      } else {
                        return null;
                      }
                    },
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
