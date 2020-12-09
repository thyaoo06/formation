import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mob/data/database.dart';
import 'package:mob/models/auto_model.dart';

class AddVehiculeDialog {
  final theModel = TextEditingController();
  final theMark = TextEditingController();
  final theName = TextEditingController();
  final theImmat = TextEditingController();
  final theKM = TextEditingController();
  final theControlDate = TextEditingController();
  Vehicule car;

  static const TextStyle linkStyle = const TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

  Widget buildAboutDialog(
      BuildContext context, _myHomePageState, bool isEdit, Vehicule car) {
    if (car != null) {
      this.car=car;
      theMark.text = car.mark;
      theModel.text = car.model;
      theName.text = car.name;
      theImmat.text = car.immat;
      theKM.text = car.kms.toString();

    }

    return new AlertDialog(
      title: new Text(isEdit ? 'Edit ' + theModel.text: 'Add new Vehicule'),
      content: new SingleChildScrollView(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getTextField("Enter Model", theModel),
            getTextField("Enter Mark", theMark),
            getTextField("Enter Name", theName),
            getTextField("Enter Immatriculation", theImmat),
            getTextField("Enter Kilometrage", theKM, TextInputType.number),

            new GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: new Container (
                 margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: getAppBorderButton(
                    "Cancel", EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
              ),
            ),
            new GestureDetector(
              onTap: () {
                addRecord(isEdit);
                _myHomePageState.displayRecord();
                Navigator.of(context).pop();
              },
              child: new Container (
                 margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: getAppBorderButton(
                    isEdit?"Update":"Add", EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTextField(
      String inputBoxName, TextEditingController inputBoxController, [TextInputType kb = TextInputType.text] ) {
    var loginBtn = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new TextFormField(
        controller: inputBoxController,
        decoration: new InputDecoration(
          hintText: inputBoxName,
        ),
        keyboardType: kb,
      ),
    );

    return loginBtn;
  }

  Widget getAppBorderButton(String buttonLabel, EdgeInsets margin) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(8.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        border: Border.all(color: const Color(0xFF28324E)),
        borderRadius: new BorderRadius.all(const Radius.circular(6.0)),
      ),
      child: new Text(
        buttonLabel,
        style: new TextStyle(
          color: const Color(0xFF28324E),
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
    );
    return loginBtn;
  }

  Future addRecord(bool isEdit) async {
    var car = new Vehicule(isEdit ? this.car.idcar : null, theMark.text, theModel.text, theName.text, theImmat.text, int.tryParse(theKM.text), null, 0, null,null);

    await DBProvider.db.saveVehicule(car,isEdit);
  }
}