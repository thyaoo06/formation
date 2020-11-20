import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mob/models/auto_model.dart';
import 'package:mob/homepresenter.dart';
import 'package:mob/models/auto_model.dart';
import 'package:mob/addcar.dart';
import 'package:mob/fillcar.dart';
import 'package:mob/data/database.dart';
import 'package:mob/editcar.dart';

class AutoList extends StatelessWidget {
  List<Vehicule> park;
  HomePresenter homePresenter;

  AutoList(
      List<Vehicule> this.park,
      HomePresenter this.homePresenter, {
        Key key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(' in build Autolist nbcar='+  park.length.toString());
    if (park.length == 0) {
      return new AddVehiculeDialog().buildAboutDialog(
          context, this, false, null);
    } else  {

    return new ListView.builder(
        itemCount: park == null ? 0 : park.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            child: new Container(
                child: new Center(
                  child: new Row(
                    children: <Widget>[
                      new CircleAvatar(
                        radius: 30.0,
                        child: new Text(getShortName(park[index])),
                        backgroundColor: const Color(0xFF20283e),
                      ),
                      new Expanded(
                        child: new Padding(
                          padding: EdgeInsets.all(10.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                park[index].name,
                                // set some style to text
                                style: new TextStyle(
                                    fontSize: 25.0,
                                    color: Colors.deepOrange),
                              ),
                              new Text(
                                park[index].model + " " + park[index].mark,
                                // set some style to text
                                style: new TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.lightBlueAccent),
                              ),
                              new Text(
                                "Km: " + park[index].kms.toString(),
                                // set some style to text
                                style: new TextStyle(
                                    fontSize: 23.0, color: Colors.green[300]),
                              ),
                              new Text(
                                "Creation: " + park[index].credt.toString(),
                                // set some style to text
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.amber),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new IconButton(
                            icon: const Icon(
                              Icons.format_color_fill,
                              color: const Color(0xFF167F67),
                            ),
                            onPressed: () => _fillCar(park[index], context),
                          ),
                          new IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: const Color(0xFF167F67),
                            ),
                            onPressed: () => edit(park[index], context),
                          ),

                          new IconButton(
                            icon: const Icon(Icons.delete_forever,
                                color: const Color(0xFF167F67)),
                            onPressed: ()  { showConfirmationDialog(context, index); },
                                //deleteCar(park[index], context),
                                //homePresenter.delete(park[index]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0)),
          );
        });
    };
  }
  displayRecord() {
    print(' before display Autolist: car = '+  park.length.toString());

    homePresenter.updateScreen();
  }

  edit(Vehicule auto, BuildContext context) {
  /*  showDialog(
      context: context,
      builder: (BuildContext context) =>
        new AddVehiculeDialog().buildAboutDialog(context, this, true, auto),

    );*/
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditCarScreen(true, auto)),
    );
    homePresenter.updateScreen();
  }

  String getShortName(Vehicule auto) {
    String shortName = "";
    if (!auto.model.isEmpty) {
      shortName = auto.model.substring(0, 1) + ".";
    }
    return shortName;
  }

  deleteCar(Vehicule car, BuildContext context) {
     DBProvider.db.deleteVehicule(car);
     homePresenter.updateScreen();
  }

  void _fillCar(Vehicule carselect, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FillScreen(car: carselect)),
    );
  }

  showConfirmationDialog(BuildContext context, int index) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {Navigator.of(context).pop();},
    );
    Widget continueButton = FlatButton(
      child: Text("Delete"),
      onPressed:  () {
        Navigator.of(context).pop();
        deleteCar(park[index], context);
        },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Vehicule"),
      content: Text("Would you really delete the vehicule and its history?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}