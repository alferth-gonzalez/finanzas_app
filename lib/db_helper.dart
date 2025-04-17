import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'finanzas.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            correo TEXT UNIQUE,
            password TEXT,
            fechaNacimiento TEXT
          )
        ''');
      },
    );
  }

  Future<int> registerUser(String nombre, String correo, String password, String fechaNacimiento) async {
    final db = await database;
    return await db.insert(
      'users',
      {
        'nombre': nombre,
        'correo': correo,
        'password': password,
        'fechaNacimiento': fechaNacimiento,
      },
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<Map<String, dynamic>?> loginUser(String correo, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'correo = ? AND password = ?',
      whereArgs: [correo, password],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<bool> emailExists(String correo) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'correo = ?',
      whereArgs: [correo],
    );
    return result.isNotEmpty;
  }
}
