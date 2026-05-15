import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/entity/category_entity.dart';

abstract class CategoriesLocalDataSource {
  Future<List<CategoryEntity>> getCategories();
}

class CategoriesLocalDataSourceImpl implements CategoriesLocalDataSource {
  static const _databaseName = "fake_store.db";
  static const _tableName = "categories";

  static const _databaseVersion = 1;

  Database? _database;

  CategoriesLocalDataSourceImpl({Database? database}) : _database = database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Note: Creating both tables for consistency across data sources
    await db.execute('''
          CREATE TABLE IF NOT EXISTS products (
            product_id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            price REAL NOT NULL,
            unit TEXT NOT NULL,
            image TEXT NOT NULL,
            discount INTEGER NOT NULL,
            availability INTEGER NOT NULL,
            brand TEXT NOT NULL,
            category TEXT NOT NULL,
            rating REAL NOT NULL,
            reviews_json TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE IF NOT EXISTS categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE
          )
          ''');

    final categories = [
      'Electronics',
      'Wearables',
      'Cameras',
      'Gaming',
      'Appliances'
    ];

    for (var category in categories) {
      await db.insert(
        'categories',
        {'name': category},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return CategoryEntity.fromMap(maps[i]);
    });
  }
}
