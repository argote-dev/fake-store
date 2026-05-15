import 'package:fake_store/common/models/result.dart';
import '../models/category.dart';

abstract class CategoriesRepository {
  Future<Result<List<Category>>> getCategories();
}
