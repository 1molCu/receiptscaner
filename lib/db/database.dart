import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'model.dart';

class DatabaseProvider {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('receipt.db');
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return await openDatabase(path, version: 1, onCreate: _createrDB);
  }

  Future _createrDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
  CREATE TABLE $table(
  id $idType,
  errorCode $textType,
  fpdm $textType,
  fphm $textType,
  gfmc $textType,
  je $textType,
  kprq $textType,
  filePath $textType)''');
  }

  Future<void> insertReceipt(Receipt receipt) async {
    final db = await database;

    final id = await db.insert(table, receipt.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Receipt>> receipts() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Receipt(
        id: maps[i]['id'],
        errorCode: maps[i]['ErrorCode'],
        fpdm: maps[i]['fpdm'],
        fphm: maps[i]['fphm'],
        gfmc: maps[i]['gfmc'],
        je: maps[i]['je'],
        kprq: maps[i]['kprq'],
        filePath: maps[i]['filePath'],
      );
    });
  }

  Future<void> updataReceipt(Receipt receipt) async {
    final db = await database;
    await db.update(
      table,
      receipt.toJson(),
      where: 'id = ?',
      whereArgs: [receipt.id],
    );
  }

  Future<void> deleteReceipt(int id) async {
    final db = await database;

    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
