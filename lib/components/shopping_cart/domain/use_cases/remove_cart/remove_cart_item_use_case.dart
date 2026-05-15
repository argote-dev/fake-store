import '../../repositories/shopping_cart_repository.dart';

class RemoveCartItemUseCase {
  final ShoppingCartRepository _repository;

  RemoveCartItemUseCase(this._repository);

  Future<void> execute(int productId, bool isExpress) async {
    await _repository.deleteCartItem(productId, isExpress);
  }
}
