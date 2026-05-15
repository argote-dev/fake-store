import 'package:fake_store/common/models/result.dart';
import '../../models/product.dart';
import '../../repositories/products_repository.dart';

class GetProductsByCategoryUseCase {
  final ProductsRepository _repository;

  GetProductsByCategoryUseCase(this._repository);

  Future<Result<List<Product>>> execute(
    String category, {
    int limit = 10,
    int offset = 0,
  }) {
    return _repository.getProductsByCategory(category, limit, offset);
  }
}
