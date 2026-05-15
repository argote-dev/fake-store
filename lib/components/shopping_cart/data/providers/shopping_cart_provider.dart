import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/shopping_cart_repository.dart';
import '../../domain/use_cases/add_product_to_cart_use_case.dart';
import '../../domain/use_cases/get_cart_use_case.dart';
import '../../domain/use_cases/remove_cart_item_use_case.dart';
import '../../domain/use_cases/update_cart_item_quantity_use_case.dart';
import '../datasources/local/shopping_cart_local_data_source.dart';
import '../repositories/shopping_cart_repository_impl.dart';

final shoppingCartLocalDataSourceProvider = Provider<ShoppingCartLocalDataSource>((ref) {
  return ShoppingCartLocalDataSource();
});

final shoppingCartRepositoryProvider = Provider<ShoppingCartRepository>((ref) {
  final localDataSource = ref.watch(shoppingCartLocalDataSourceProvider);
  return ShoppingCartRepositoryImpl(localDataSource);
});

final addProductToCartUseCaseProvider = Provider<AddProductToCartUseCase>((ref) {
  final repository = ref.watch(shoppingCartRepositoryProvider);
  return AddProductToCartUseCase(repository);
});

final getCartUseCaseProvider = Provider<GetCartUseCase>((ref) {
  final repository = ref.watch(shoppingCartRepositoryProvider);
  return GetCartUseCase(repository);
});

final updateCartItemQuantityUseCaseProvider = Provider<UpdateCartItemQuantityUseCase>((ref) {
  final repository = ref.watch(shoppingCartRepositoryProvider);
  return UpdateCartItemQuantityUseCase(repository);
});

final removeCartItemUseCaseProvider = Provider<RemoveCartItemUseCase>((ref) {
  final repository = ref.watch(shoppingCartRepositoryProvider);
  return RemoveCartItemUseCase(repository);
});
