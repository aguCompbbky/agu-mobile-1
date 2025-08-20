import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

extension DbDebug on DatabaseService {
  Future<void> debugPrintDbInfo() async {
    final path = await _dbPath();
    final f = File(path);
    print(
        'DB PATH: $path  | exists=${await f.exists()}  | size=${await f.length()} bytes');

    final d = await db;
    final tables = await d.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name");
    print('TABLES: ${tables.map((e) => e['name']).toList()}');

    for (final t in tables) {
      final name = t['name'] as String;
      final cnt = await d.rawQuery('SELECT COUNT(*) as c FROM $name');
      print('COUNT($name) = ${cnt.first['c']}');
    }
  }
}

class DatabaseService {
  DatabaseService._();
  static final DatabaseService I = DatabaseService._();
  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<String> _dbPath() async {
    final dir = await getApplicationSupportDirectory();
    return p.join(dir.path, 'lessons.db');
  }

  Future<void> _ensureLocalCopy() async {
    final dst = await _dbPath();
    final f = File(dst);
    if (!await f.exists()) {
      final bytes = await rootBundle.load('assets/db/lessons.db');
      await f.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    }
  }

  Future<Database> _open() async {
    await _ensureLocalCopy();
    final path = await _dbPath();
    return openDatabase(path, readOnly: true);
  }
}
