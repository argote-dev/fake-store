import '../models/cart_item.dart';

abstract class ShoppingCartRepository {
  Future<List<CartItem>> getCartItems(bool isExpress);
  Future<void> saveCartItem(CartItem item);
  Future<void> updateQuantity(int productId, bool isExpress, int quantity);
  Future<void> deleteCartItem(int productId, bool isExpress);
  Future<void> clearCart(bool isExpress);
}
