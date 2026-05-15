import 'package:fake_store/network/model/result/result.dart';
import '../models/product.dart';

abstract class ProductsRepository {
  Future<Result<List<Product>>> getProducts();
  Future<Result<List<Product>>> getProductsByCategory(String category, int limit, int offset);
  Future<Result<List<Product>>> searchProducts(String query, int limit, int offset);
}
