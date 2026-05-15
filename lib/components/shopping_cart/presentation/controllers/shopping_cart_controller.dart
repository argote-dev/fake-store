import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/cart_item.dart';
import '../../data/providers/shopping_cart_provider.dart';
import '../../../products/domain/models/product.dart';

class ShoppingCartController extends AsyncNotifier<List<CartItem>> {
  final bool isExpress;

  ShoppingCartController(this.isExpress);

  @override
  FutureOr<List<CartItem>> build() async {
    return ref.read(getCartUseCaseProvider).execute(isExpress);
  }

  Future<void> addProduct(Product product) async {
    final currentItems = state.value ?? [];
    final existingIndex = currentItems.indexWhere(
      (item) => item.productId == product.productId,
    );

    if (existingIndex != -1) {
      await updateQuantity(
        product.productId,
        currentItems[existingIndex].quantity + 1,
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
      
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        await ref.read(addProductToCartUseCaseProvider).execute(newItem);
        return [...currentItems, newItem];
      });
    }
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    final currentItems = state.value ?? [];
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(updateCartItemQuantityUseCaseProvider)
          .execute(productId, isExpress, quantity);

      if (quantity <= 0) {
        return currentItems.where((item) => item.productId != productId).toList();
      } else {
        return [
          for (final item in currentItems)
            if (item.productId == productId)
              item.copyWith(quantity: quantity)
            else
              item,
        ];
      }
    });
  }

  Future<void> removeProduct(int productId) async {
    final currentItems = state.value ?? [];
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(removeCartItemUseCaseProvider).execute(productId, isExpress);
      return currentItems.where((item) => item.productId != productId).toList();
    });
  }

  Future<void> clearCart() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(clearCartUseCaseProvider).execute(isExpress);
      return [];
    });
  }
}

final shoppingCartProvider =
    AsyncNotifierProvider.family<ShoppingCartController, List<CartItem>, bool>(
      ShoppingCartController.new,
    );
