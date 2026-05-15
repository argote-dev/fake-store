import 'package:fake_store/network/model/result/result.dart';
import '../../models/product.dart';
import '../../repositories/products_repository.dart';

class SearchProductsUseCase {
  final ProductsRepository _repository;

  SearchProductsUseCase(this._repository);

  Future<Result<List<Product>>> execute(
    String query, {
    int limit = 10,
    int offset = 0,
  }) {
    return _repository.searchProducts(query, limit, offset);
  }
}
