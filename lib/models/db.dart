import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model.dart';
import 'package:path_provider/path_provider.dart';

const kTableCategory = 'catalogs';
const kDatabaseVersion = 1;
const kDatabaseName = 'catalogs.db';
const kSQLCreateStatement = '''CREATE TABLE $kTableCategory (
id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
name TEXT NOT NULL, 
status INTEGER NOT NULL DEFAULT 0,
)''';

class DB {
  DB._();

  static final DB _db = DB._();

  factory DB() => _db;

  Database _database;

  Future<Database> get database async {
    // ?? = null 의 경우
    return _database ?? await initDB();
  }

  Future<Database> initDB() async {
    Directory docsDirectory = await getApplicationDocumentsDirectory();
    String path = join(docsDirectory.path, kDatabaseName);

    return await openDatabase(path, version: kDatabaseVersion,
        onCreate: (Database db, int version) async {
          await db.execute(kSQLCreateStatement);
        });
  }

  createCatalog(Catalog catalog) async {
    final db = await database;
    await db.insert(kTableCategory, catalog.toMapAutoID());
  }

  deleteCatalog(int id) async {
    final db = await database;
    await db.delete(kTableCategory, where: 'id=?', whereArgs: [id]);
  }
  Future<List<Catalog>> getAllCatalog() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM $kTableCategory'");
    return List.generate(maps.length, (i) {
      return Catalog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        status: maps[i]['status'],
      );
    }
    );
  }
  // randomOption(String catalog) async {
  //   final db = await database;
  //   var res = await db.rawQuery("SELECT * FROM $kTableCategory WHERE catalog IN($catalog)");
  //   List<Category> list = res.isNotEmpty ? res.map((c) => Category.fromMap(c)).toList() : [];
  //   return list;
  // }

}
