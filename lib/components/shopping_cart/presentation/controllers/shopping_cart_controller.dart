import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/cart_item.dart';
import '../../data/providers/shopping_cart_provider.dart';
import '../../../products/domain/models/product.dart';

class ShoppingCartController extends Notifier<List<CartItem>> {
  final bool isExpress;

  ShoppingCartController(this.isExpress);

  @override
  List<CartItem> build() {
    _loadCart();
    return [];
  }

  Future<void> _loadCart() async {
    final items = await ref.read(getCartUseCaseProvider).execute(isExpress);
    state = items;
  }

  Future<void> addProduct(Product product) async {
    final existingIndex = state.indexWhere(
      (item) => item.productId == product.productId,
    );

    if (existingIndex != -1) {
      await updateQuantity(
        product.productId,
        state[existingIndex].quantity + 1,
      );
    } else {
      final newItem = CartItem(
        productId: product.productId,
        name: product.name,
        image: product.image,
        price: product.price,
        unit: product.unit,
        quantity: 1,
        isExpress: isExpress,
      );
      await ref.read(addProductToCartUseCaseProvider).execute(newItem);
      state = [...state, newItem];
    }
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    await ref
        .read(updateCartItemQuantityUseCaseProvider)
        .execute(productId, isExpress, quantity);

    if (quantity <= 0) {
      state = state.where((item) => item.productId != productId).toList();
    } else {
      state = [
        for (final item in state)
          if (item.productId == productId)
            item.copyWith(quantity: quantity)
          else
            item,
      ];
    }
  }

  Future<void> removeProduct(int productId) async {
    await ref.read(removeCartItemUseCaseProvider).execute(productId, isExpress);
    state = state.where((item) => item.productId != productId).toList();
  }

  Future<void> clearCart() async {
    await ref.read(clearCartUseCaseProvider).execute(isExpress);
    state = [];
  }
}

final shoppingCartProvider =
    NotifierProvider.family<ShoppingCartController, List<CartItem>, bool>(
      ShoppingCartController.new,
    );
