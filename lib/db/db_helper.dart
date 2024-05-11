import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wear_counter/model/cloth.dart';

class DBHelper {
  // create database
  Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    return openDatabase(
      join(path, 'wear_counter.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE clothing_items(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, imagePath TEXT, wearCount INTEGER, currentWears INTEGER)",
        );
      },
      version: 1,
    );
  }

  // get Database path
  Future<String> getDatabasePath() async {
    final directory = await getDatabasesPath();
    final path = join(directory, 'wear_counter.db');

    return path;
  }

  // Insert
  Future<int> insertClothingItem(Cloth cloth) async {
    final Database db = await initDatabase();
    return db.insert(
      'clothing_items',
      cloth.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // get all
  Future<List<Cloth>> getClothingItems() async {
    final Database db = await initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('clothing_items');
    return List.generate(maps.length, (i) {
      return Cloth(
        id: maps[i]['id'],
        name: maps[i]['name'],
        imagePath: maps[i]['imagePath'],
        wearCount: maps[i]['wearCount'],
        currentWears: maps[i]['currentWears'],
      );
    });
  }

  // delete by id
  Future<int> deleteClothingItem(int id) async {
    final Database db = await initDatabase();
    return await db.delete(
      'clothing_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // update
  Future<int> updateClothingItem(Cloth cloth) async {
    final Database db = await initDatabase();
    return await db.update(
      'clothing_items',
      cloth.toMap(),
      where: 'id = ?',
      whereArgs: [cloth.id],
    );
  }

  // get row count
  Future<int?> getRowCount() async {
    final Database db = await initDatabase();
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT COUNT(*) FROM clothing_items');
    int? count = Sqflite.firstIntValue(result);
    return count;
  }

  // print all rows
  Future<void> printAllRows() async {
    final Database database = await initDatabase();
    List<Map<String, dynamic>> rows = await database.query('clothing_items');
    rows.forEach((row) {
      print('Row: $row');
    });
  }
}
