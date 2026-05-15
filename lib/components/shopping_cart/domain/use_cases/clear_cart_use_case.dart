import '../repositories/shopping_cart_repository.dart';

class ClearCartUseCase {
  final ShoppingCartRepository repository;

  ClearCartUseCase(this.repository);

  Future<void> execute(bool isExpress) {
    return repository.clearCart(isExpress);
  }
}
