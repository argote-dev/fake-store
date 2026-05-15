import 'package:fake_store/network/model/result/result.dart';
import '../models/category.dart';

abstract class CategoriesRepository {
  Future<Result<List<Category>>> getCategories();
}
