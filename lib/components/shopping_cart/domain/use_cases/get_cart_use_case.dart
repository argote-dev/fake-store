import '../models/cart_item.dart';
import '../repositories/shopping_cart_repository.dart';

class GetCartUseCase {
  final ShoppingCartRepository _repository;

  GetCartUseCase(this._repository);

  Future<List<CartItem>> execute(bool isExpress) async {
    return await _repository.getCartItems(isExpress);
  }
}
