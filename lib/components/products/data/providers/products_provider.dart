import 'package:fake_store/network/router/provider/network_provider.dart';
import 'package:riverpod/riverpod.dart';
import '../../domain/repositories/products_repository.dart';
import '../../domain/use_cases/get_products/get_products_use_case.dart';
import '../datasources/local/products_local_data_source.dart';
import '../datasources/remote/products_remote_data_source.dart';
import '../repositories/products_repository_impl.dart';

final productsRemoteDataSourceProvider = Provider<ProductsRemoteDataSource>((ref) {
  final network = ref.watch(networkProvider);
  return ProductsRemoteDataSourceImpl(network);
});

final productsLocalDataSourceProvider = Provider<ProductsLocalDataSource>((ref) {
  return ProductsLocalDataSourceImpl();
});

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final remote = ref.watch(productsRemoteDataSourceProvider);
  final local = ref.watch(productsLocalDataSourceProvider);
  return ProductsRepositoryImpl(remote, local);
});

final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  final repository = ref.watch(productsRepositoryProvider);
  return GetProductsUseCase(repository);
});
