import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mob/models/auto_model.dart';
import 'package:mob/models/refill_model.dart';


class DBProvider {
    // Create a singleton
    DBProvider._();

    static final DBProvider db = DBProvider._();
    Database _database;

    Future<Database> get database async {
        if (_database != null) {
            return _database;
        }

        _database = await initDB();
        return _database;
    }

    initDB() async {

        Directory documentsDir = await getApplicationDocumentsDirectory();
        String path = join(documentsDir.path, 'car_db.db');

        return await openDatabase(path, version: 7, onOpen: (db) async {}, onCreate: _onCreate, onUpgrade: _onUpgrade);
    }

    void _onCreate (Database db, int version) async {
        print ('creating ... version => $version');
        await db.execute('''
                CREATE TABLE Vehicule (
                    idcar INTEGER PRIMARY KEY AUTOINCREMENT,
                    mark TEXT,
                    model TEXT,
                    name TEXT,
                    immat TEXT,
                    kms INTEGER,
                    kmsdt String DEFAULT CURRENT_TIMESTAMP,            
                    idlasteny INTEGER,
                    credt String DEFAULT CURRENT_TIMESTAMP,            
                    visctdt String DEFAULT CURRENT_TIMESTAMP            
                )
            ''');
        await db.execute('''
                CREATE TABLE Param (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    idcar INTEGER,
                    idenergy INTEGER,
                    logdt String DEFAULT CURRENT_TIMESTAMP ,
                    lastvisctdt String DEFAULT CURRENT_TIMESTAMP             
                )
            ''');
        await db.execute('''
                CREATE TABLE Refill (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    idcar INTEGER,
                    qte INTEGER,
                    price INTEGER,
                    idenergy INTEGER,
                    kms INTEGER,
                    credt String DEFAULT CURRENT_TIMESTAMP,
                    idwhere INTEGER           
                )
            ''');
        await db.execute('''
                CREATE TABLE Rappel (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    idcar INTEGER,
                    notif String,
                    credt String DEFAULT CURRENT_TIMESTAMP,
                    kms INTEGER,
                    dt String,
                    status String           
                )
            ''');
        await db.execute('''
                CREATE TABLE Maintenance (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    idcar INTEGER,
                    comment String,
                    credt String DEFAULT CURRENT_TIMESTAMP,
                    idfacture INTEGER       
                )
            ''');

        await db.execute('''
                CREATE TABLE Facture (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    idcar INTEGER,
                    operation String,
                    cout String,
                    credt String DEFAULT CURRENT_TIMESTAMP,        
                    idmaintenance INTEGER       
                )
            ''');

    }

    void _onUpgrade (Database db, int oldVersion, int newVersion) async {
        print(' in _onUpgrade database from '+oldVersion.toString()+' to '+newVersion.toString());
         if (oldVersion < newVersion) {
             await db.execute("ALTER TABLE Vehicule ADD COLUMN kmsdt String");
             await db.execute("ALTER TABLE Vehicule ADD COLUMN idenergy INTEGER");
         }
    }

Future<List<Vehicule>> getVehicules() async {
    final db = await database;
    var res = await db.query('Vehicule');
    List<Vehicule> vehicules = res.isNotEmpty ?
        List.generate(res.length, (i) {    // print(' new CAR credt='+  res[i]['credt'].toString());

        return Vehicule(
                res[i]['idcar'],
                res[i]['mark'],
            res[i]['model'],
            res[i]['name'],
                res[i]['immat'],
            res[i]['kms'],
            res[i]['kmsdt'],
            res[i]['idlasteny'],
                res[i]['credt'],
                res[i]['visctdt']
            );
        }) : [];
    return vehicules;
    }

    Future<int> saveVehicule(Vehicule car, bool isEdit) async {
        final db = await database;
        int res;
        if (isEdit) {
            res = await db.update("Vehicule", car.toMap(),where: 'idcar=?',whereArgs: [car.idcar]);
        } else {
            res = await db.insert("Vehicule", car.toMap());
        }
        return res;
    }

    Future<int> deleteVehicule(Vehicule car) async {
        final db = await database;
        int res;
        res = await db.delete("Vehicule", where: 'idcar=?',whereArgs: [car.idcar]);
        return res;
    }

    Future<int> saveRefill(Refill rf) async {
        final db = await database;
        int res = await db.insert("Refill", rf.toMap());
        return res;
    }

}