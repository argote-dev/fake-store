import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ShoppingCartLocalDataSource {
  static Database? _database;
  static const String tableName = 'cart_items';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'shopping_cart.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            product_id INTEGER,
            name TEXT,
            image TEXT,
            price REAL,
            unit TEXT,
            quantity INTEGER,
            is_express INTEGER
          )
        ''');
      },
    );
  }

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
