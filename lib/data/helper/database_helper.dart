import 'package:restaurant_submissions/data/model/restaurants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblFavorites = 'favorites';

  /// init database
  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/restaurantapps.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblFavorites (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        pictureId TEXT,
        city TEXT,
        rating REAL
      )
      ''');
      },
      version: 1,
    );
    return db;
  }

  /// getting database
  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initializeDb();
    }

    return _database;
  }

  /// insert item favorite to database
  Future<void> insertFavorite(Restaurants restaurants) async {
    final db = await database;
    print(restaurants.name);
    await db!.insert(_tblFavorites, restaurants.toJson());
  }

  /// get all favorites
  Future<List<Restaurants>> getFavorites() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblFavorites);

    return results.map((res) => Restaurants.fromJson(res)).toList();
  }

  /// get by id favorites
  Future<Map> getFavoriteById(String id) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(
      _tblFavorites,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  /// remove favorites
  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db!.delete(
      _tblFavorites,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
