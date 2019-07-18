import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:QRPreguntados/Pregunta.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';

class PreguntaDB {
  PreguntaDB._();

  static final PreguntaDB db = PreguntaDB._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "preguntas.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Pregunta ("
          "id integer primary key unique,"
          "pregunta TEXT,"
          "opcionUno TEXT,"
          "opcionDos TEXT,"
          "opcionTres TEXT,"
          "respuesta TEXT,"
          "correcto TEXT"
          ")");
    });
  }

  //Query
  Future<List<Pregunta>> getPreguntas() async {
    final db = await database;
    var result = await db.query("Pregunta");
    List<Pregunta> list = result.map((c) => Pregunta.fromMap(c)).toList();
    return list;
  }

  //Query
  Future<Pregunta> getPregunta(int id) async {
    final db = await database;
    var result = await db.query("Pregunta", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? Pregunta.fromMap(result.first) : null;
  }

  //Insert
  addPregunta(Pregunta preg) async {
    final db = await database;
    /*var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Pregunta");
    int id = table.first["id"];
    preg.id = id;*/
    var raw = await db.insert(
      "Pregunta",
      preg.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return raw;
  }

  //Delete
  //Delete client with id
  deletePregunta(int id) async {
    final db = await database;
    return db.delete("Pregunta", where: "id = ?", whereArgs: [id]);
  }

  //Delete all clients
  resetDB() async {
    final db = await database;
    db.delete("Pregunta");
  }

  //Update
  updateCorrecto(int id, String correcto) async {
    final db = await database;
    var result = await db.rawUpdate(
        "FROM Pregunta SET correcto = ? WHERE id = ?", [correcto, id]);
    return result;
  }
}
