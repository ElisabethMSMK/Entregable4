import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/report_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('reports.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const reportTable = '''
    CREATE TABLE reports (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      severity TEXT NOT NULL,  -- Cambiado a TEXT para almacenar el valor del enum
      status TEXT NOT NULL,    -- Cambiado a TEXT para almacenar el valor del enum
      date TEXT NOT NULL
    );
    ''';
    await db.execute(reportTable);
  }

  Future<int> createReport(ReportModel report) async {
    final db = await instance.database;
    return await db.insert('reports', report.toMap());
  }

  Future<List<ReportModel>> readAllReports() async {
    final db = await instance.database;
    final result = await db.query('reports');
    return result.map((json) => ReportModel.fromMap(json)).toList();
  }

  Future<int> updateReport(ReportModel report) async {
    final db = await instance.database;
    return db.update(
      'reports',
      report.toMap(),
      where: 'id = ?',
      whereArgs: [report.id],
    );
  }

  Future<int> deleteReport(int id) async {
    final db = await instance.database;
    return db.delete(
      'reports',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
