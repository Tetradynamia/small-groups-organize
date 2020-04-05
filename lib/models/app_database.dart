import 'dart:async';

import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class AppDatabase {
  static void _createDb(sql.Database db) {
    db.execute(
        'CREATE TABLE groups (groupId TEXT PRIMARY KEY, groupName TEXT, groupDescription TEXT)');
    db.execute(
        'CREATE TABLE members (memberId TEXT PRIMARY KEY, memberName TEXT, groupName TEXT)');
        db.execute(
        'CREATE TABLE history (id INTEGER PRIMARY KEY AUTOINCREMENT, dateTime TEXT, groupName TEXT, smallGroups TEXT, note TEXT)');
  }

  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'database.db'),
        onCreate: (db, version) {
      return _createDb(db);
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await AppDatabase.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await AppDatabase.database();
    return db.query(table);
  }

    static Future<int> delete(String table, String where, String id) async {
      final db = await AppDatabase.database();
    return await db.delete('$table', where: '$where = ?', whereArgs: [id]);
  }


  static Future<void> updateGoup(String id, Map<String, Object> data) async {
    final db = await AppDatabase.database();
    return await db.update('groups', data,
        where: 'groupId = ?', whereArgs: [id]);
  }

   static Future<void> updateMember(String id, Map<String, Object> data) async {
    final db = await AppDatabase.database();
    return await db.update('members', data,
        where: 'memberId = ?', whereArgs: [id]);
  }
}
