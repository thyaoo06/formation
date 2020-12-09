
import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mob/models/auto_model.dart';
import 'package:mob/models/refill_model.dart';
import 'package:mob/data/database.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class EditCarScreen extends StatelessWidget {
  final bool isEdit;
  final Vehicule car;

  EditCarScreen(this.isEdit, this.car) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit?"Edite véhicule "+car.name:"Ajoute un véhicule")),
      body: Center(
        child: myFormEditCar(isEdit, car),
      ),
    );
  }
}

// Define a custom Form widget.
class myFormEditCar extends StatefulWidget {
  final bool isEdit;
  final Vehicule car;
  myFormEditCar(this.isEdit, this.car) : super();
  @override
  MyFormEditCarState createState() {
    return MyFormEditCarState(isEdit, car);
  }
}


// Define a corresponding State class.
// This class holds data related to the form.
class MyFormEditCarState extends State<myFormEditCar> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final bool isEdit;
  Vehicule car;
  MyFormEditCarState(this.isEdit, this.car) : super();
  final focusModel = FocusNode();
  final focusName = FocusNode();
  final focusImmat = FocusNode();
  final focusKms = FocusNode();
  final focusContDate = FocusNode();

  List<String> _carbus = ['SP95-98 E5', 'SP98 E10', 'Gazole B7', 'GPL', 'Ethanol E85'];
  String _selectedCarbu;

  final TextEditingController _textMarkController = new TextEditingController();
  final TextEditingController _textModelController = new TextEditingController();
  final TextEditingController _textNameController = new TextEditingController();
  final TextEditingController _textImmatController = new TextEditingController();
  final TextEditingController _textKmsController = new TextEditingController();
  final TextEditingController _textContDateController = new TextEditingController();


  @override
  void initState() {
    super.initState();
    if (isEdit) {
      _textMarkController.text = car.mark;
      _textModelController.text = car.model;
      _textImmatController.text = car.immat;
      _textKmsController.text = car.kms.toString();
      _textContDateController.text = car.visctdt;
      _selectedCarbu = _carbus[car.idlasteny];
    }

  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      autovalidate: false,
      child: ListView(
      //  crossAxisAlignment: CrossAxisAlignment.start,
       // mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildMarkField(),
          _buildModelField(),
          _buildNameField(),
          _buildImmatField(),
          _buildKmsField(),
          _buildContDateField(),
          _buildSubmitButton(),
        ],
      ),
    );


    Future<void> dispose() async {
      _textMarkController.dispose();
      _textModelController.dispose();
      _textNameController.dispose();
      _textImmatController.dispose();
      _textKmsController.dispose();
      _textContDateController.dispose();
      super.dispose();
    }
  }

  Widget _buildMarkField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Marque: '
      ),
      controller: _textMarkController,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(focusModel);
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Saisie marque (Dacia, Audi,...)';
        }
        return null;
      },
      onSaved: (String value) {
        car.mark = value;
      },
    );
  }

  Widget _buildModelField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Modele: '
      ),
      controller: _textModelController,
      validator: (value) {
        if (value.isEmpty) {
          return 'Saisie modèle (Sandero, 308,...)';
        }
       return null;
      },
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(focusName);
      },
      onSaved: (String value) {
        car.model = value;
      },
      focusNode: focusModel,
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Nom: '
      ),
      controller: _textNameController,
      validator: (value) {
        if (value.isEmpty) {
          return 'Saisie nom';
        }
        return null;
      },
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(focusImmat);
      },
      onSaved: (String value) {
        car.name = value;
      },
      focusNode: focusName,
    );
  }

  Widget _buildImmatField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Immatriculation: '
      ),
      controller: _textImmatController,
      validator: (value) {
        if (value.isEmpty) {
          return 'Saisie plaque immatriculation ';
        }
      },
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(focusKms);
      },
      onSaved: (String value) {
        car.immat = value;
      },
      focusNode: focusImmat,
    );
  }

  Widget _buildKmsField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Kilométrage: '
      ),
      controller: _textKmsController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty) {
          return 'Saisie total kilométres';
        }
        if (int.tryParse(value) < car.kms) {
          return 'total kilometres doit être sup. ' + car.kms.toString();
        }        return null;
      },
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(focusContDate);
      },
      onSaved: (String value) {
        car.kms = int.tryParse(value);
      },
      focusNode: focusKms,
    );
  }

  Widget _buildContDateField() {
    return DateTimePickerFormField(
      inputType: InputType.date,
      format: DateFormat("dd-MM-yyyy"),
      initialDate: DateTime.now(),
      decoration: InputDecoration(
          labelText: 'Controle Technique: ',
          hasFloatingPlaceholder: false,
      ),
      controller: _textContDateController,
      onSaved: (DateTime  value) {
        var formatter = new DateFormat('dd-MM-yyyy');
        car.visctdt = formatter.format(value);
      },
      //focusNode: focusImmat,
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

     DBProvider.db.saveVehicule(car, true);

  }
}