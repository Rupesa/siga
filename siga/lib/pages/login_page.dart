import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:siga/pages/root_app.dart';
import 'package:siga/theme/colors.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class Login_Page extends StatefulWidget {
  const Login_Page({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Login_Page> {
  bool isAuth = false;

  @override
  initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((account) {
      if (account != null) {
        print("User signed in!: $account");
        setState(() {
          isAuth = true;
        });
      } else {
        setState(() {
          isAuth = false;
        });
      }
    }, onError: (err) {
      print("Error signing in: $err");
    });
  }

  login() {
    try {
      googleSignIn.signIn();
    } on PlatformException catch (err) {
      // Handle err
    } catch (err) {
      // other types of Exceptions
    }
  }

  logout() {
    try {
      //googleSignIn.signOut();
      print("pressed");
    } on PlatformException catch (err) {
      // Handle err
    } catch (err) {
      // other types of Exceptions
    }
  }

  Widget buildAuthScreen() {
    return MaterialApp(home: RootApp());
    // return TextButton(
    //   child: Text("Logout"),
    //   onPressed: logout(),
    // );
    // return Text("Authenticated");
  }

  Widget buildUnAuthScreen() {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.teal,
            Colors.purple,
          ])),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Siga",
            style: TextStyle(
              fontFamily: "Signatra",
              fontSize: 90,
              color: white,
            ),
          ),
          SizedBox(
            height: 70,
          ),
          GestureDetector(
            onTap: login(),
            // onTap: print("Pressed"),
            child: Container(
                width: 230,
                height: 50,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/google_logo.png"),
                  fit: BoxFit.cover,
                ))),
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
