import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('students.db');
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

    await db.execute('''
    CREATE TABLE students(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT
    )
    ''');
  }

  // ajouter étudiant
  Future<int> insertStudent(String name) async {
    final db = await instance.database;

    return await db.insert(
      'students',
      {'name': name},
    );
  }

  // afficher étudiants
  Future<List<Map<String, dynamic>>> getStudents() async {
    final db = await instance.database;

    return await db.query('students');
  }

  // modifier étudiant
  Future<int> updateStudent(int id, String name) async {
    final db = await instance.database;

    print("UPDATE ID: $id NAME: $name");

    return await db.update(
      'students',
      {'name': name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // supprimer étudiant
  Future<int> deleteStudent(int id) async {
    final db = await instance.database;

    return await db.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}