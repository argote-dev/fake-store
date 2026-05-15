import 'package:fake_store/network/model/http/http_method.dart';
import 'package:fake_store/network/model/http/http_route.dart';
import 'package:fake_store/common/models/result.dart';
import 'package:fake_store/network/router/network_router.dart';
import '../../models/dto/product_response.dart';
import '../../models/path/products_path.dart';

abstract class ProductsRemoteDataSource {
  Future<Result<List<ProductResponse>>> getProducts();
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final NetworkRouter _router;

  ProductsRemoteDataSourceImpl(this._router);

  @override
  Future<Result<List<ProductResponse>>> getProducts() async {
    final route = HttpRoute(
      path: ProductsPath(),
      method: HttpMethod.get,
    );

    final result = await _router.fetch<dynamic>(route);

    return result.map((data) {
      final list = data as List<dynamic>;
      return list.map((e) => ProductResponse.fromJson(e as Map<String, dynamic>)).toList();
    });
  }
}
