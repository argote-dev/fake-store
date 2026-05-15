import '../../domain/models/cart_item.dart';
import '../../domain/repositories/shopping_cart_repository.dart';
import '../datasources/local/shopping_cart_local_data_source.dart';

class ShoppingCartRepositoryImpl implements ShoppingCartRepository {
  final ShoppingCartLocalDataSource _localDataSource;

  ShoppingCartRepositoryImpl(this._localDataSource);

  @override
  Future<List<CartItem>> getCartItems(bool isExpress) async {
    final maps = await _localDataSource.getCartItems(isExpress);
    return maps.map((map) => CartItem.fromMap(map)).toList();
  }

  @override
  Future<void> saveCartItem(CartItem item) async {
    await _localDataSource.saveCartItem(item.toMap());
  }

  @override
  Future<void> updateQuantity(int productId, bool isExpress, int quantity) async {
    await _localDataSource.updateQuantity(productId, isExpress, quantity);
  }

  @override
  Future<void> deleteCartItem(int productId, bool isExpress) async {
    await _localDataSource.deleteCartItem(productId, isExpress);
  }

  @override
  Future<void> clearCart(bool isExpress) async {
    await _localDataSource.clearCart(isExpress);
  }
}
