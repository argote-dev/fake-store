import 'package:fake_store/network/model/result/result.dart';
import '../../domain/models/product.dart';
import '../../domain/repositories/products_repository.dart';
import '../mappers/product_mapper.dart';
import '../datasources/local/products_local_data_source.dart';
import '../datasources/remote/products_remote_data_source.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource _remoteDataSource;
  final ProductsLocalDataSource _localDataSource;

  ProductsRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Result<List<Product>>> getProducts() async {
    try {
      final localProducts = await _localDataSource.getProducts();

      if (localProducts.isNotEmpty) {
        return Result.success(
          localProducts
              .map((e) => ProductMapper.fromEntityToDomain(e))
              .toList(),
        );
      }

      final remoteResult = await _remoteDataSource.getProducts();

      return remoteResult.when(
        success: (dtos) async {
          final entities = dtos
              .map((e) => ProductMapper.fromDtoToEntity(e))
              .toList();
          await _localDataSource.saveProducts(entities);
          return Result.success(
            dtos.map((e) => ProductMapper.fromDtoToDomain(e)).toList(),
          );
        },
        failure: (error) => Result.failure(error),
      );
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<Product>>> getProductsByCategory(
    String category,
    int limit,
    int offset,
  ) async {
    try {
      var localProducts = await _localDataSource.getProductsByCategory(
        category,
        limit,
        offset,
      );

      if (localProducts.isNotEmpty) {
        return Result.success(
          localProducts
              .map((e) => ProductMapper.fromEntityToDomain(e))
              .toList(),
        );
      }

      // If local is empty and offset is 0, fetch from remote and cache all
      if (offset == 0) {
        final remoteResult = await _remoteDataSource.getProducts();

        return await remoteResult.when(
          success: (dtos) async {
            final entities = dtos
                .map((e) => ProductMapper.fromDtoToEntity(e))
                .toList();
            await _localDataSource.saveProducts(entities);

            // Re-query local with category and pagination
            localProducts = await _localDataSource.getProductsByCategory(
              category,
              limit,
              offset,
            );

            return Result.success(
              localProducts
                  .map((e) => ProductMapper.fromEntityToDomain(e))
                  .toList(),
            );
          },
          failure: (error) async => Result.failure(error),
        );
      }

      return Result.success([]);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<Product>>> searchProducts(
    String query,
    int limit,
    int offset,
  ) async {
    try {
      var localProducts = await _localDataSource.searchProducts(
        query,
        limit,
        offset,
      );

      if (localProducts.isNotEmpty) {
        return Result.success(
          localProducts
              .map((e) => ProductMapper.fromEntityToDomain(e))
              .toList(),
        );
      }

      // If local is empty and offset is 0, fetch from remote and cache all
      if (offset == 0) {
        final remoteResult = await _remoteDataSource.getProducts();

        return await remoteResult.when(
          success: (dtos) async {
            final entities = dtos
                .map((e) => ProductMapper.fromDtoToEntity(e))
                .toList();
            await _localDataSource.saveProducts(entities);

            // Re-query local with search and pagination
            localProducts = await _localDataSource.searchProducts(
              query,
              limit,
              offset,
            );

            return Result.success(
              localProducts
                  .map((e) => ProductMapper.fromEntityToDomain(e))
                  .toList(),
            );
          },
          failure: (error) async => Result.failure(error),
        );
      }

      return Result.success([]);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}
