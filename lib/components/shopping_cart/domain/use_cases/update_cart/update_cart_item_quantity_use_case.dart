import '../../repositories/shopping_cart_repository.dart';

class UpdateCartItemQuantityUseCase {
  final ShoppingCartRepository _repository;

  UpdateCartItemQuantityUseCase(this._repository);

  Future<void> execute(int productId, bool isExpress, int quantity) async {
    if (quantity <= 0) {
      await _repository.deleteCartItem(productId, isExpress);
    } else {
      await _repository.updateQuantity(productId, isExpress, quantity);
    }
  }
}
