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
      version: 2,
      onCreate: (db, version) async {
        await _crearTablas(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE gastos (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              categoria TEXT,
              monto INTEGER,
              descripcion TEXT,
              fecha TEXT
            )
          ''');
        }
      },
    );
  }

  Future<void> _crearTablas(Database db) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        correo TEXT UNIQUE,
        password TEXT,
        fechaNacimiento TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE gastos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        categoria TEXT,
        monto INTEGER,
        descripcion TEXT,
        fecha TEXT
      )
    ''');
  }

  // ================= USUARIOS =================

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

  // ================= GASTOS =================

  Future<void> insertarGasto(String categoria, int monto, String descripcion, String fecha) async {
    final db = await database;
    await db.insert(
      'gastos',
      {
        'categoria': categoria,
        'monto': monto,
        'descripcion': descripcion,
        'fecha': fecha,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }



  Future<List<Map<String, dynamic>>> obtenerGastosPorCategoria(String categoria) async {
    final db = await database;
    return await db.query(
      'gastos',
      where: 'categoria = ?',
      whereArgs: [categoria],
      orderBy: 'fecha DESC',
    );
  }

  Future<Map<String, int>> totalesPorCategoria() async {
    final db = await database;
    final resultado = await db.rawQuery(
      'SELECT categoria, SUM(monto) AS total FROM gastos GROUP BY categoria'
    );
    return {
      for (var fila in resultado)
        fila['categoria'] as String: fila['total'] as int
    };
  }
}
