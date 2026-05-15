import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/entity/category_entity.dart';

abstract class CategoriesLocalDataSource {
  Future<List<CategoryEntity>> getCategories();
}

class CategoriesLocalDataSourceImpl implements CategoriesLocalDataSource {
  static const _databaseName = "fake_store.db";
  static const _tableName = "categories";

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
    // Note: Database creation and seeding are handled in ProductsLocalDataSourceImpl
    return await openDatabase(path);
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
