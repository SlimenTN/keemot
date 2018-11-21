import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'model.dart';

class DatabaseHandler{
  static final DatabaseHandler _instance = DatabaseHandler.internal();
  factory DatabaseHandler() => _instance;
  DatabaseHandler.internal();

  final String _table = 'task';
  final String _columnId = 'id';
  final String _columnTite = 'title';
  final String _columnDate = 'date';
  final String _columnTime = 'time';
  final String _columnReiteration = 'reiteration';
  final String _columnReiterationTarget = 'reiterationTarget';
  final String _columnNotification = 'notification';
  final String _columnNotificationTarget = 'notificationTarget';

  static Database _db;

  Future<Database> get db async{
    if(_db != null)  return _db;
    _db = await initDB();
    return _db;
  } 

  initDB() async{
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'keemot.db');

    var ourDB = await openDatabase(path, version: 1, onCreate: _onCreat);
    return ourDB;
  }

  void _onCreat(Database db, int version) async{
    await db.execute(
      'CREATE TABLE $_table ('
        '$_columnId INTEGER PRIMARY KEY,'
        '$_columnTite TEXT,'
        '$_columnDate TEXT,'
        '$_columnTime TEXT,'
        '$_columnReiteration INTEGER,'
        '$_columnReiterationTarget TEXT,'
        '$_columnNotification INTEGER,'
        '$_columnNotificationTarget TEXT'
      ')'
    );
  }

  // close connection
  Future close() async{
    var dbClient = await db;
    return dbClient.close();
  }

  // Create
  Future<int> create(Task task)async {
    var dbClient = await db;
    int res = await dbClient.insert(_table, task.toMap());
    return res;
  }

  // Read
  Future<List> read() async{
    var dbClient = await db;
    var res = await dbClient.rawQuery('SELECT * FROM $_table');
    return res.toList();// we can get rid of .toList() function
  }
}