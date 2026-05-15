import 'package:sqflite/sqflite.dart';
import '../../models/entity/category_entity.dart';
import '../../../../../database/database_service.dart';

abstract class CategoriesLocalDataSource {
  Future<List<CategoryEntity>> getCategories();
}

class CategoriesLocalDataSourceImpl implements CategoriesLocalDataSource {
  static const _tableName = "categories";

  final DatabaseService _databaseService;
  final Database? _database;

  CategoriesLocalDataSourceImpl({DatabaseService? databaseService, Database? database}) 
      : _databaseService = databaseService ?? DatabaseService(),
        _database = database;

  Future<Database> get database async => _database ?? await _databaseService.database;

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return CategoryEntity.fromMap(maps[i]);
    });
  }
}
