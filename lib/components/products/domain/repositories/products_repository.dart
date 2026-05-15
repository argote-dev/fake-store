import 'package:fake_store/network/model/result/result.dart';
import '../models/product.dart';

abstract class ProductsRepository {
  Future<Result<List<Product>>> getProducts();
}
