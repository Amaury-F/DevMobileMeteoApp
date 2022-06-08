import 'dart:math';

import 'package:sqflite/sqflite.dart';
import 'package:flutter_meteo_app/models/cities.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    String pathDB = await getDatabasesPath();
    String path = join(pathDB, 'cities.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cities (
        name TEXT
      )
      ''');
  }

  Future<List> getCities() async {
    Database db = await _initDatabase();
    final List<Map<String, Object?>> queryResult =
        await db.query('cities', orderBy: 'name');
    return queryResult.map((e) => Cities.fromMap(e)).toList();
  }

  Future<int> addCities(Cities city) async {
    Database db = await _initDatabase();
    return await db.insert('cities', city.toMap());
  }

  Future<int> removeCities(Cities city) async {
    Database db = await _initDatabase();
    return await db.delete('cities', where: 'name = ?', whereArgs: [city.name]);
  }
}
