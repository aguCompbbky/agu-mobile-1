import 'dart:core';

import 'package:home_page/utilts/models/lesson.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Dbhelper {
  Database? _db;

  Future<void> incrementAttendanceByCount(String name, int count) async {
    Database db = await this.db;
    String lowerName = name.trim().toLowerCase();
    await db.rawUpdate(
      'UPDATE lessons SET attendance = attendance + ? WHERE LOWER(TRIM(name)) = ?',
      [count, lowerName],
    );
  }

  Future<int> getAttendanceByLessonName(String name) async {
    Database db = await this.db;
    String lowerName = name.trim().toLowerCase();
    var result = await db.rawQuery(
      'SELECT attendance FROM lessons WHERE LOWER(TRIM(name)) = ? LIMIT 1',
      [lowerName],
    );
    if (result.isNotEmpty) {
      return result.first['attendance'] as int;
    } else {
      return 0;
    }
  }

  Future<void> incrementAttendanceForLessonNameLowercase(String name) async {
    Database db = await this.db;
    String lowerName = name.trim().toLowerCase(); // ← güncel hali
    await db.rawUpdate(
      'UPDATE lessons SET attendance = attendance + 1 WHERE LOWER(TRIM(name)) = ?',
      [lowerName],
    );
  }

  Future<Database> get db async {
    _db ??= await initializeDb();

    return _db!;
  }

  Future<Database> initializeDb() async {
    String dbPath = join(await getDatabasesPath(), "timeTable.db");
    var timeTableDb = openDatabase(dbPath, version: 1, onCreate: createDb);
    return timeTableDb;
  }

  void createDb(Database db, int version) async {
    await db.execute(
        "Create table lessons(id integer primary key, name text, place text, day text, hour1 text, hour2 text, hour3 text, attendance INTEGER DEFAULT 0, isProcessed INTEGER DEFAULT 0)");
  }

  Future<List<Lesson>> getLessons() async {
    Database db = await this.db;
    var result = await db.query("lessons");
    return List.generate(result.length, (i) {
      return Lesson.fromObject(result[i]);
    });
  }

  Future<int> insert(Lesson lesson) async {
    Database db = await this.db;
    var result = await db.insert("lessons", lesson.toMap());
    return result;
  }

  Future<int> delete(int id) async {
    Database db = await this.db;
    var result = await db.rawDelete("DELETE FROM lessons WHERE id = ?", [id]);
    return result;
  }

  Future<int> update(Lesson lesson) async {
    Database db = await this.db;
    var result = await db.update("lessons", lesson.toMap(),
        where: "id =?", whereArgs: [lesson.id]);
    return result;
  }

  void deleteDatabaseFile() async {
    String dbPath = join(await getDatabasesPath(), "timeTable.db");
    await deleteDatabase(dbPath); // Veritabanını tamamen sil
  }
}
