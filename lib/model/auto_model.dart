import 'package:intl/intl.dart';

class Vehicule {
  final int _idcar;
  String _mark;
  String _model;
  String _name;

  String _immat;
  int _kms;
  String _kmsdt;
  int _idlasteny;
  final String credt;
  String _visctdt;

  Vehicule(this._idcar, this._mark, this._model, this._immat, this._name,
      this._kms, this._kmsdt, this._idlasteny, this.credt, this._visctdt);

  String get name => _name;

  set name(String value) {
    _name = value;
  } // Convert a Vehicule into a Map. The keys must correspond to the _names of the

  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'idcar': _idcar,
      'mark': _mark,
      'model': _model,
      'name': _name ?? _model + ' ' + _mark,
      'immat': _immat,
      'kms': _kms,
      'kmsdt': _kmsdt ??
          new DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()),
      'idlasteny': _kmsdt,
      'credt':
          credt ?? new DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()),
      'visctdt': _visctdt
    };
  }

  setLastEnergy(int ideny) {
    this._idlasteny = ideny;
    this._kmsdt = new DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now());
  }

  String get visctdt => _visctdt;

  set visctdt(String value) {
    _visctdt = value;
  }

  int get idlasteny => _idlasteny ?? 0;

  String get kmsdt => _kmsdt;

  set kmsdt(String value) {
    _kmsdt = value;
  }

  int get kms => _kms;

  set kms(int value) {
    _kms = value;
  }

  String get immat => _immat;

  set immat(String value) {
    _immat = value;
  }

  String get model => _model;

  set model(String value) {
    _model = value;
  }

  String get mark => _mark;

  set mark(String value) {
    _mark = value;
  }

  int get idcar => _idcar;
}
