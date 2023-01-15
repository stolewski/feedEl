import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';

class DBProvider {
  static Future<Database> dbFeedings() async {
    final dbPath = join(await sql.getDatabasesPath(), 'feedings.db');
    return sql.openDatabase(dbPath, onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE feeding (id INTEGER PRIMARY KEY AUTOINCREMENT, time TEXT, type TEXT, side TEXT, quantity TEXT, note TEXT, eructated TEXT, date TEXT)');
    }, version: 1);
  }

  static Future<void> insertFeeding(
      String table, Map<String, Object> data) async {
    final db = await DBProvider.dbFeedings();

    await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getFeedings(String table) async {
    final db = await DBProvider.dbFeedings();
    return db.query(table);
  }

  static Future<Database> dbDays() async {
    final dbPath = join(await sql.getDatabasesPath(), 'days.db');
    return sql.openDatabase(dbPath, onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE day (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT)');
    }, version: 1);
  }

  static Future<void> insertDay(String table, Map<String, String> day) async {
    final dbDay = await DBProvider.dbDays();

    await dbDay.insert(
      table,
      day,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getDays(String table) async {
    final db = await DBProvider.dbDays();
    return db.query(table);
  }
}
