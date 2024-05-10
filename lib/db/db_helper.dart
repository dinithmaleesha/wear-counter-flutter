import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wear_counter/model/cloth.dart';

class DBHelper {
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

  // Insert
  // Future<int> insertClothingItem(Cloth cloth) async {
  //   final Database db = await initDatabase();
  //   return db.insert(
  //     'clothing_items',
  //     cloth.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  // get
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
}
