import 'package:flutter/material.dart';
import 'pages/LoginPage.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Catalogue Formations",
      theme: ThemeData(primarySwatch: Colors.red),
      home: LoginPage(),
    );
  }
}
