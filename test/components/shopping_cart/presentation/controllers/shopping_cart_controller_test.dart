import 'package:fake_store/components/products/domain/models/product.dart';
import 'package:fake_store/components/shopping_cart/data/providers/shopping_cart_provider.dart';
import 'package:fake_store/components/shopping_cart/domain/models/cart_item.dart';
import 'package:fake_store/components/shopping_cart/domain/repositories/shopping_cart_repository.dart';
import 'package:fake_store/components/shopping_cart/presentation/controllers/shopping_cart_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'shopping_cart_controller_test.mocks.dart';

@GenerateMocks([ShoppingCartRepository])
void main() {
  late MockShoppingCartRepository mockRepository;
  late ProviderContainer container;

  final tProduct = Product(
    productId: 1,
    name: 'Test Product',
    description: 'Test Description',
    price: 100.0,
    unit: 'Unit',
    image: 'image_url',
    discount: 10,
    availability: true,
    brand: 'Brand',
    category: 'Category',
    rating: 4.5,
  );

  setUp(() {
    mockRepository = MockShoppingCartRepository();
    container = ProviderContainer(
      overrides: [
        shoppingCartRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ShoppingCartController - Standard Mode', () {
    test('should add a product to the cart', () async {
      // Given
      when(mockRepository.getCartItems(false)).thenAnswer((_) async => []);
      when(mockRepository.saveCartItem(any)).thenAnswer((_) async => {});
      
      final controller = container.read(shoppingCartProvider(false).notifier);

      // When
      await controller.addProduct(tProduct);

      // Then
      final state = container.read(shoppingCartProvider(false));
      expect(state.value?.length, 1);
      expect(state.value?.first.productId, tProduct.productId);
      expect(state.value?.first.quantity, 1);
      verify(mockRepository.saveCartItem(any)).called(1);
    });

    test('should update quantity when product already in cart', () async {
      // Given
      final existingItem = CartItem(
        productId: tProduct.productId,
        name: tProduct.name,
        image: tProduct.image,
        price: tProduct.price,
        unit: tProduct.unit,
        quantity: 1,
        isExpress: false,
      );
      when(mockRepository.getCartItems(false)).thenAnswer((_) async => [existingItem]);
      when(mockRepository.updateQuantity(any, any, any)).thenAnswer((_) async => {});
      
      final controller = container.read(shoppingCartProvider(false).notifier);
      await container.read(shoppingCartProvider(false).future); // Wait for build

      // When
      await controller.addProduct(tProduct);

      // Then
      final state = container.read(shoppingCartProvider(false));
      expect(state.value?.first.quantity, 2);
      verify(mockRepository.updateQuantity(tProduct.productId, false, 2)).called(1);
    });

    test('should remove item when quantity becomes 0', () async {
      // Given
      final existingItem = CartItem(
        productId: tProduct.productId,
        name: tProduct.name,
        image: tProduct.image,
        price: tProduct.price,
        unit: tProduct.unit,
        quantity: 1,
        isExpress: false,
      );
      when(mockRepository.getCartItems(false)).thenAnswer((_) async => [existingItem]);
      when(mockRepository.deleteCartItem(any, any)).thenAnswer((_) async => {});
      
      final controller = container.read(shoppingCartProvider(false).notifier);
      await container.read(shoppingCartProvider(false).future); // Wait for build

      // When
      await controller.updateQuantity(tProduct.productId, 0);

      // Then
      final state = container.read(shoppingCartProvider(false));
      expect(state.value?.isEmpty, true);
      verify(mockRepository.deleteCartItem(tProduct.productId, false)).called(1);
    });

    test('should clear the cart', () async {
      // Given
      final existingItem = CartItem(
        productId: tProduct.productId,
        name: tProduct.name,
        image: tProduct.image,
        price: tProduct.price,
        unit: tProduct.unit,
        quantity: 2,
        isExpress: false,
      );
      when(mockRepository.getCartItems(false)).thenAnswer((_) async => [existingItem]);
      when(mockRepository.clearCart(false)).thenAnswer((_) async => {});
      
      final controller = container.read(shoppingCartProvider(false).notifier);
      await container.read(shoppingCartProvider(false).future); // Wait for build

      // When
      await controller.clearCart();

      // Then
      final state = container.read(shoppingCartProvider(false));
      expect(state.value?.isEmpty, true);
      verify(mockRepository.clearCart(false)).called(1);
    });
  });

  group('ShoppingCartController - Express Mode', () {
    test('should add a product to the express cart', () async {
      // Given
      when(mockRepository.getCartItems(true)).thenAnswer((_) async => []);
      when(mockRepository.saveCartItem(any)).thenAnswer((_) async => {});
      
      final controller = container.read(shoppingCartProvider(true).notifier);

      // When
      await controller.addProduct(tProduct);

      // Then
      final state = container.read(shoppingCartProvider(true));
      expect(state.value?.length, 1);
      expect(state.value?.first.isExpress, true);
      verify(mockRepository.saveCartItem(argThat(predicate((CartItem item) => item.isExpress)))).called(1);
    });
  });
}
