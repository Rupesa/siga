import 'package:flutter/material.dart';
import 'package:siga/pages/login_page.dart';
import 'pages/root_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'src/widgets.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:provider/provider.dart'; // new
import 'src/authentication.dart'; // new
import "pages/login_page.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    //home: RootApp(),
    home: Login_Page(),
  ));
}
