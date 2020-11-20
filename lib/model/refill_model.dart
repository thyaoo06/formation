
class Refill {
  final int _id;
  final int _idcar;
  final int _qte;
  final int _price;
  final int _idEnergy;
  final int _kms;
  final String _credt;
  final int _idwhere;

  Refill(this._id, this._idcar, this._qte, this._price, this._idEnergy, this._kms, this._credt, this._idwhere);


  // Convert a Object into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'idcar': _idcar,
      'qte': _qte,
      'price': _price,
      '_idEnergy': _idEnergy,
      'kms': _kms,
      'credt': _credt,
      'idwhere': _idwhere
    };
  }
}
