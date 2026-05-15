import 'package:sqflite/sqflite.dart';
import '../../../../../database/database_service.dart';

class ShoppingCartLocalDataSource {
  static const String tableName = 'cart_items';
  final DatabaseService _databaseService;
  final Database? _database;

  ShoppingCartLocalDataSource({DatabaseService? databaseService, Database? database}) 
      : _databaseService = databaseService ?? DatabaseService(),
        _database = database;

  Future<Database> get database async => _database ?? await _databaseService.database;

  Future<void> saveCartItem(Map<String, dynamic> item) async {
    final db = await database;
    await db.insert(
      tableName,
      item,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getCartItems(bool isExpress) async {
    final db = await database;
    return await db.query(
      tableName,
      where: 'is_express = ?',
      whereArgs: [isExpress ? 1 : 0],
    );
  }

  Future<void> updateQuantity(int productId, bool isExpress, int quantity) async {
    final db = await database;
    await db.update(
      tableName,
      {'quantity': quantity},
      where: 'product_id = ? AND is_express = ?',
      whereArgs: [productId, isExpress ? 1 : 0],
    );
  }

  Future<void> deleteCartItem(int productId, bool isExpress) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'product_id = ? AND is_express = ?',
      whereArgs: [productId, isExpress ? 1 : 0],
    );
  }

  Future<void> clearCart(bool isExpress) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'is_express = ?',
      whereArgs: [isExpress ? 1 : 0],
    );
  }
}
