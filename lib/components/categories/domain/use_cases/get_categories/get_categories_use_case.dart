import 'package:fake_store/network/model/result/result.dart';
import '../../models/category.dart';
import '../../repositories/categories_repository.dart';

class GetCategoriesUseCase {
  final CategoriesRepository _repository;

  GetCategoriesUseCase(this._repository);

  Future<Result<List<Category>>> execute() {
    return _repository.getCategories();
  }
}
