import 'package:flutter/material.dart';
import 'dart:developer';

import '../Cours.dart';
import 'InfoPage.dart';

final crs = List<Cours>.generate(10,
    (i) => Cours("Cours Logiciel $i", "description $i", "images/abarth.png"));

class ListFormations extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListFormations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page List"),
      ),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            Cours cours =
                new Cours(crs[index].name, crs[index].desc, crs[index].image);
            return Container(
              height: 70,
              child: ListTile(
                onTap: () {
                  log("tap");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InfoPage(cours: cours)));
                },
                leading: Image.asset(cours.image),
                title: Text(cours.name),
                subtitle: Row(
                  children: <Widget>[Text("29.99 e - 4.5"), Icon(Icons.star)],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemCount: crs.length),
    );
  }
}
