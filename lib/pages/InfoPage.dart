import 'package:flutter/material.dart';
import 'dart:developer';

import '../Cours.dart';

class InfoPage extends StatefulWidget {
  final Cours cours;

  const InfoPage({Key key, this.cours}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Info " + widget.cours.name),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildDetail(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar,
    );
  }

  Widget _buildHeader() {
    return new Container(
      child: Image.asset(widget.cours.image),
    );
  }

  Widget _buildDetail() {
    return new Container(
      padding: EdgeInsets.all(20),
      child: Column(children: <Widget>[
        Text(
          widget.cours.name,
          style: TextStyle(fontSize: 26),
        ),
        SizedBox(height: 15),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(widget.cours.desc),
        ),
        SizedBox(height: 15),
        Text("Price: 20.5"),
      ]),
    );
  }
}
