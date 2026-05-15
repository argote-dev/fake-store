import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/entity/product_entity.dart';

abstract class ProductsLocalDataSource {
  Future<List<ProductEntity>> getProducts();
  Future<void> saveProducts(List<ProductEntity> products);
  Future<void> clearProducts();
}

class ProductsLocalDataSourceImpl implements ProductsLocalDataSource {
  static const _databaseName = "fake_store.db";
  static const _tableName = "products";
  static const _databaseVersion = 1;

  Database? _database;

  ProductsLocalDataSourceImpl({Database? database}) : _database = database;

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
    await db.execute('''
          CREATE TABLE $_tableName (
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
          CREATE TABLE categories (
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
  Future<List<ProductEntity>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return ProductEntity.fromMap(maps[i]);
    });
  }

  @override
  Future<void> saveProducts(List<ProductEntity> products) async {
    final db = await database;
    final batch = db.batch();
    for (var product in products) {
      batch.insert(
        _tableName,
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> clearProducts() async {
    final db = await database;
    await db.delete(_tableName);
  }
}
