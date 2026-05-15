import '../../models/cart_item.dart';
import '../../repositories/shopping_cart_repository.dart';

class AddProductToCartUseCase {
  final ShoppingCartRepository _repository;

  AddProductToCartUseCase(this._repository);

  Future<void> execute(CartItem item) async {
    await _repository.saveCartItem(item);
  }
}
