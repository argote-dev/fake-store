import 'package:fake_store/network/model/result/result.dart';
import '../../models/product.dart';
import '../../repositories/products_repository.dart';

class GetProductsUseCase {
  final ProductsRepository _repository;

  GetProductsUseCase(this._repository);

  Future<Result<List<Product>>> execute() {
    return _repository.getProducts();
  }
}
