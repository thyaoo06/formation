import 'package:flutter/material.dart';
import 'pages/HomePage.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Parc véhicule",
      theme: ThemeData(primarySwatch: Colors.red),
      home: HomePage(),
    );
  }
}
