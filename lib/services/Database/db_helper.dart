import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'health_record.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('health.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE health_records (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL UNIQUE,
            steps INTEGER NOT NULL,
            calories INTEGER NOT NULL,
            water INTEGER NOT NULL,
            created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
          )
        ''');
      },
    );
  }
  Future<int> insertHealthRecord(HealthRecord record) async {
    final db = await instance.database;
    return await db.insert(
      'health_records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<HealthRecord>> getAllRecords() async {
  final db = await instance.database;

  final List<Map<String, dynamic>> maps =
      await db.query('health_records', orderBy: 'date DESC'); // newest first [web:2][web:143]

  return List.generate(maps.length, (i) {
      return HealthRecord(
        id: maps[i]['id'] as int,
        date: maps[i]['date'] as String,
        steps: maps[i]['steps'] as int,
        calories: maps[i]['calories'] as int,
        water: maps[i]['water'] as int,
      );
    }); // convert each row (Map) into HealthRecord object. [web:2][web:143][web:146]
  }

  Future<List<HealthRecord>> getRecords({String? date}) async {
  final db = await instance.database;

  final maps = date == null
      ? await db.query('health_records', orderBy: 'date DESC')
      : await db.query(
          'health_records',
          where: 'date = ?',
          whereArgs: [date],
          orderBy: 'date DESC',
      ); // basic SELECT query in sqflite.

        return maps.map((m) => HealthRecord(
          id: m['id'] as int,
          date: m['date'] as String,
          steps: m['steps'] as int,
          calories: m['calories'] as int,
          water: m['water'] as int,
        )).toList(); // map rows to objects.
  }

  Future<int> deleteRecord(int id) async {
  final db = await instance.database;
  return db.delete('health_records', where: 'id = ?', whereArgs: [id]); // [web:2][web:144]
}

Future<int> updateHealthRecord(HealthRecord record) async {
  final db = await instance.database;
  return db.update(
    'health_records',
    record.toMap(),
    where: 'id = ?',
    whereArgs: [record.id],
  ); // standard UPDATE in sqflite. [web:2][web:143]
}

Future<HealthRecord?> getRecordByDate(String date) async {
  final db = await instance.database;

  final maps = await db.query(
    'health_records',
    where: 'date = ?',
    whereArgs: [date],
    limit: 1,
  ); // simple SELECT with WHERE. [web:2][web:142]

  if (maps.isEmpty) return null;

  final m = maps.first;
  return HealthRecord(
    id: m['id'] as int,
    date: m['date'] as String,
    steps: m['steps'] as int,
    calories: m['calories'] as int,
    water: m['water'] as int,
  );
}


}
