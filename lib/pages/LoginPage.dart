import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:formations/pages/ListFormations.dart';

class LoginPage extends StatelessWidget {
  String mail = "";
  String pwd = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ma Page de Login"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            SizedBox(height: 20),
            _buildTitle(),
            _buildForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return new Container(
      child: Image.network(
          "https://www.developpez.com/template/images/logo-dvp-h55.png"),
    );
  }

  Widget _buildTitle() {
    return new Center(
      child: Text("Connectez-vous", style: TextStyle(fontSize: 28)),
    );
  }

  Widget _buildForm(BuildContext context) {
    return new Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          new Container(
            child: TextFormField(
              onChanged: (newtext) {
                mail = newtext;
              },
              decoration: InputDecoration(labelText: "Your email..."),
            ),
          ),
          SizedBox(height: 10),
          new Container(
            child: TextFormField(
              decoration: InputDecoration(labelText: "Your password..."),
              obscureText: true,
              onChanged: (newtext) {
                pwd = newtext;
              },
            ),
          ),
          SizedBox(height: 50),
          new Container(
            child: RaisedButton(
              child: Text("Login"),
              color: Colors.red,
              onPressed: () {
                if (mail == "123") {
                  // && pwd == "123") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListFormations()));
                } else {
                  log("Erreur indentifiant");
                }
              },
            ),
          ),
          new Container(
            child: FlatButton(
              child: Text("Forget password ?"),
              onPressed: () {
                // TODO: manage the click
                log("forget password...");
              },
            ),
          )
        ],
      ),
    );
  }
}
