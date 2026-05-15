import 'package:fake_store/common/models/result.dart';
import '../../domain/models/category.dart';
import '../../domain/repositories/categories_repository.dart';
import '../datasources/local/categories_local_data_source.dart';
import '../mappers/category_mapper.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesLocalDataSource _localDataSource;

  CategoriesRepositoryImpl(this._localDataSource);

  @override
  Future<Result<List<Category>>> getCategories() async {
    try {
      final entities = await _localDataSource.getCategories();
      final domainCategories = entities
          .map((e) => CategoryMapper.fromEntityToDomain(e))
          .toList();
      return Result.success(domainCategories);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}
