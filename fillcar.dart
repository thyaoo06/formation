
import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mob/models/auto_model.dart';
import 'package:mob/models/refill_model.dart';
import 'package:mob/data/database.dart';


class FillScreen extends StatelessWidget {
  final Vehicule car;

  FillScreen({Key key, @required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Faire le plein de '+car.name)),
      body: Center(
        child: myFormFill(car),
      ),
    );
  }
}

// Define a custom Form widget.
class myFormFill extends StatefulWidget {

  final Vehicule car;
  myFormFill(this.car) : super();
  @override
  MyFormFillState createState() {
    return MyFormFillState(car);
  }
}


// Define a corresponding State class.
// This class holds data related to the form.
class MyFormFillState extends State<myFormFill> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final Vehicule car;
  MyFormFillState(this.car) : super();
  Map<String, dynamic> formData = {'idcar': null, 'qte': null, 'km': null};
  final focusKM = FocusNode();
  final focusCarbu = FocusNode();

  List<String> _carbus = ['SP95-98 E5', 'SP98 E10', 'Gazole B7', 'GPL', 'Ethanol E85'];
  String _selectedCarbu;

  final TextEditingController _textQtyController = new TextEditingController();
  final TextEditingController _textKMController = new TextEditingController();
  @override
  void initState() {
    formData['idcar'] = car.idcar;
    super.initState();
    _textKMController.text = car.kms.toString();
    print(' in MyFormFillState car.idlasteny='+car.idlasteny.toString());
    _selectedCarbu = _carbus[car.idlasteny];

  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      autovalidate: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildQtyField(),
          _buildQTotalKMsField(),
          _buildCarburantGroup(),
          _buildSubmitButton(),
        ],
      ),
    );


    Future<void> dispose() async {
      _textQtyController.dispose();
      _textKMController.dispose();
      super.dispose();
    }
  }

  Widget _buildQtyField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Nombre de litres: '
      ),
      controller: _textQtyController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(focusKM);
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Saisie quantite obligatoire';
        }
        return null;
      },
      onSaved: (String value) {
        formData['qte'] = value;
      },
    );
  }

  Widget _buildQTotalKMsField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Kilométrage: '
      ),
      controller: _textKMController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty) {
          return 'Saisie total Kilométrage au compteur';
        }
        if (int.tryParse(value) < car.kms) {
          return 'total kilometres doit être supérieur à ' + car.kms.toString();
        }        return null;
      },
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(focusCarbu);
      },
      onSaved: (String value) {
        formData['km'] = value;
      },
      focusNode: focusKM,
    );
  }

  Widget  _buildCarburantGroup () {
    return DropdownButton(
        hint: Text('Please choose a carburant'),
        value: _selectedCarbu,
        onChanged: (newValue) {
        setState(() {
          _selectedCarbu = newValue;
        });
        },
        items: _carbus.map((carbu) {
          return DropdownMenuItem(
            child: new Text(carbu),
            value: carbu
          );
        }).toList(),
      focusNode: focusCarbu,
      isExpanded: true,
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: RaisedButton(
            onPressed: () {
              _submitForm();
            },
            child: Text('Save'),
          ),
        );
  }

  void _submitForm() {
    print('Submitting form');
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save(); //onSaved is called!
      // If the form is valid, display a Snackbar.
      Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('Processing Data')));
      addRecord();
      Navigator.pop(context);
    }
  }

   addRecord()  {
    var fill = new Refill( null, formData['idcar'], int.tryParse(formData['qte']),
        20, _carbus.indexOf(_selectedCarbu),int.tryParse(formData['km']), new DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()), 0);

     DBProvider.db.saveRefill(fill);

    car.kms = int.tryParse(formData['km']);
    car.setLastEnergy(_carbus.indexOf(_selectedCarbu));

     DBProvider.db.saveVehicule(car, true);

  }
}