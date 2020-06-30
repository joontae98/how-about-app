import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model.dart';
import 'package:path_provider/path_provider.dart';

const kTableCategory = 'categorys';
const kDatabaseVersion = 1;
const kDatabaseName = 'categorys.db';
const kSQLCreateStatement = '''CREATE TABLE $kTableCategory (
id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
option TEXT NOT NULL, 
catalog TEXT NOT NULL 
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

  createCategory(Category category) async {
    final db = await database;
    await db.insert(kTableCategory, category.toMapAutoID());
  }

  deleteOption(int id) async {
    final db = await database;
    await db.delete(kTableCategory, where: 'id=?', whereArgs: [id]);
  }

  deleteCatalog(String allCatalog) async {
    final db = await database;
    await db.delete(kTableCategory, where: 'catalog=?', whereArgs: [allCatalog]);
  }

  Future<List<Category>> getAllCatalog() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
    await db.rawQuery('SELECT DISTINCT catalog FROM $kTableCategory');
    return List.generate(maps.length, (i) {
      return Category(
        catalog: maps[i]['catalog'],
      );
    });
  }

  Future<List<Category>> getOption(String catalog) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM $kTableCategory WHERE catalog like '$catalog'");
    return List.generate(maps.length, (i) {
      return Category(
        id: maps[i]['id'],
        catalog: maps[i]['catalog'],
        option: maps[i]['option'],
      );
    }
    );
  }
  Future<List<Category>> category() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(kTableCategory);
    maps.forEach((Category)=>print(Category));
    return List.generate(maps.length, (i) {
      return Category(
        id: maps[i]['id'],
        catalog: maps[i]['catalog'],
        option: maps[i]['option'],
      );
    });
  }
  randomOption(String catalog) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM $kTableCategory WHERE catalog IN($catalog)");
    List<Category> list = res.isNotEmpty ? res.map((c) => Category.fromMap(c)).toList() : [];
    return list;
  }

}
