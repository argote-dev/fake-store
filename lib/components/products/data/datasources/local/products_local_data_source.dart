import 'package:sqflite/sqflite.dart';
import '../../models/entity/product_entity.dart';
import '../../../../../database/database_service.dart';

abstract class ProductsLocalDataSource {
  Future<List<ProductEntity>> getProducts();
  Future<List<ProductEntity>> getProductsByCategory(String category, int limit, int offset);
  Future<List<ProductEntity>> searchProducts(String query, int limit, int offset);
  Future<void> saveProducts(List<ProductEntity> products);
  Future<void> clearProducts();
}

class ProductsLocalDataSourceImpl implements ProductsLocalDataSource {
  static const _tableName = "products";

  final DatabaseService _databaseService;
  final Database? _database;

  ProductsLocalDataSourceImpl({DatabaseService? databaseService, Database? database}) 
      : _databaseService = databaseService ?? DatabaseService(),
        _database = database;

  Future<Database> get database async => _database ?? await _databaseService.database;

  @override
  Future<List<ProductEntity>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return ProductEntity.fromMap(maps[i]);
    });
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory(String category, int limit, int offset) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'category = ?',
      whereArgs: [category],
      limit: limit,
      offset: offset,
    );
    return List.generate(maps.length, (i) {
      return ProductEntity.fromMap(maps[i]);
    });
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query, int limit, int offset) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      limit: limit,
      offset: offset,
    );
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
