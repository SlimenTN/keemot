import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'model.dart';
import 'settings_model.dart';

class DatabaseHandler{
  static final DatabaseHandler _instance = DatabaseHandler.internal();
  factory DatabaseHandler() => _instance;
  DatabaseHandler.internal();

  // task table properties
  final String _table = 'task';
  final String _columnId = 'id';
  final String _columnTite = 'title';
  final String _columnDate = 'date';
  final String _columnTime = 'time';
  final String _columnMonth = 'month';
  final String _columnDay = 'day';
  final String _columnReiteration = 'reiteration';
  final String _columnReiterationTarget = 'reiterationTarget';
  final String _columnNotification = 'notification';
  final String _columnNotificationTarget = 'notificationTarget';

  // settings table properties
  final String _settingsTable = 'settings';
  final String _settingsColumnId = 'id';
  final String _settingsColumnLang = 'lang';

  static Database _db;

  Future<Database> get db async{
    if(_db != null)  return _db;
    _db = await initDB();
    return _db;
  } 

  initDB() async{
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'keemot.db');

    var ourDB = await openDatabase(
      path, 
      version: 10,
      onCreate: _onCreat,
      onUpgrade: _onUpgrade,
      );
    return ourDB;
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async{
    print('upgrading ... old: $oldVersion, new: $newVersion');
    await db.execute("DROP TABLE IF EXISTS $_table");
    await db.execute("DROP TABLE IF EXISTS $_settingsTable");
    _onCreat(db, newVersion);
  }

  void _onCreat(Database db, int version) async{
    print ('creating ... version => $version');
    await db.execute(
      'CREATE TABLE $_table ('
        '$_columnId INTEGER PRIMARY KEY,'
        '$_columnTite TEXT,'
        '$_columnDate TEXT,'
        '$_columnTime TEXT,'
        '$_columnMonth INTEGER,'
        '$_columnDay INTEGER,'
        '$_columnReiteration INTEGER,'
        '$_columnReiterationTarget TEXT,'
        '$_columnNotification INTEGER,'
        '$_columnNotificationTarget TEXT'
      ')'
    );

    await db.execute(
        'CREATE TABLE $_settingsTable ('
          '$_settingsColumnId INTEGER PRIMARY KEY,'
          '$_settingsColumnLang VARCHAR (3)'
        ')'
    );
  }

  // read saved settings from database
  Future<Settings> readSettings() async{
    var dbClient = await db;
    var res = await dbClient.rawQuery('SELECT * FROM $_settingsTable');
    var data = res.toList();
    if(data.length == 0)
      return Settings.empty();
    else
      return Settings.Map(res.toList()[0]);
  }

  void saveSettings(Settings settings) async{
    var dbClient = await db;
    if(settings.id == null)
      await dbClient.insert(_settingsTable, settings.toMap());
    else
      await dbClient.update(
          _settingsTable,
          settings.toMap(),
          where: '$_settingsColumnId = ?',
          whereArgs: [settings.id]
      );
  }

  // close connection
  Future close() async{
    var dbClient = await db;
    return dbClient.close();
  }

  // Create
  Future<int> create(Task task)async {
    print('getting db');
    var dbClient = await db;
    print('creating task: ${task.toMap().toString()}');
    int res = await dbClient.insert(_table, task.toMap());
    return res;
  }

  // Edit task
  Future<int> edit(Task task, int id)async {
    var dbClient = await db;
    return await dbClient.update(
      _table, 
      task.toMap(),
      where: '$_columnId = ?',
      whereArgs: [id]
    );
  }

  // Read
  Future<List> read() async{
    var dbClient = await db;
    var res = await dbClient.rawQuery('SELECT * FROM $_table ORDER BY id DESC');
    return res.toList();// we can get rid of .toList() function
  }

  Future<List> readComingEvents(int days) async{
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * from $_table WHERE DATE($_columnDate) BETWEEN DATE('now') AND DATE('now', '+$days day') ORDER BY DATE($_columnDate) ASC");
    return res.toList();
  }

  Future<int> delete(int id) async{
    var dbClient = await db;
    var res = await dbClient.delete(
      _table,
      where: '$_columnId = ?',
      whereArgs: [id]
    );

    return res;
  }
}