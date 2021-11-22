import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:siga/model/user.dart';
import 'package:siga/pages/root_app.dart';
import 'package:siga/theme/colors.dart';
import 'create_account_page.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final CollectionReference usersRef =
    FirebaseFirestore.instance.collection("users");
final DateTime timestamp = DateTime.now();
User? currentUser;

class Login_Page extends StatefulWidget {
  //const Login_Page({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Login_Page> {
  bool isAuth = false;

  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((account) async {
      if (account != null) {
        print("User signed in!: $account");
        await createUserInFirestore();
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

  createUserInFirestore() async {
    //check if user exists
    final GoogleSignInAccount? user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.doc(user!.id).get();

    if (!doc.exists) {
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));

      usersRef.doc(user.id).set({
        "id": user.id,
        "username": username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "timestamp": timestamp,
      });
      doc = await usersRef.doc(user.id).get();
    }
    currentUser = User.fromDocument(doc);
    print("Heyyy");
    print("Heyy");
    print("Hey");
    print(currentUser);
  }

  login() {
    try {
      googleSignIn.signOut();
      googleSignIn.signIn();
    } on PlatformException catch (err) {
      // Handle err
    } catch (err) {
      // other types of Exceptions
    }
  }

  logout() {
    try {
      googleSignIn.signOut();
      //print("pressed");
    } on PlatformException catch (err) {
      // Handle err
    } catch (err) {
      // other types of Exceptions
    }
  }

  Widget buildAuthScreen() {
    return MaterialApp(home: RootApp(currentUser: currentUser));
    // return TextButton(
    //   child: Text("Logout"),
    //   onPressed: () => logout(),
    // );
    // return Text("Authenticated");
  }

  Scaffold buildUnAuthScreen() {
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
            //onTap: login(),
            onTap: () => login(),
            child: Container(
                width: 230,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
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
    //return isAuth ? buildAuthScreen() : buildUnAuthScreen();
    return buildAuthScreen();
  }
}
