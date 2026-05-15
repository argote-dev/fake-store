import 'package:fake_store/components/shopping_cart/domain/repositories/shopping_cart_repository.dart';
import 'package:fake_store/components/shopping_cart/domain/use_cases/clear_cart/clear_cart_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'clear_cart_use_case_test.mocks.dart';

@GenerateMocks([ShoppingCartRepository])
void main() {
  late MockShoppingCartRepository mockRepository;
  late ClearCartUseCase useCase;

  setUp(() {
    mockRepository = MockShoppingCartRepository();
    useCase = ClearCartUseCase(mockRepository);
  });

  test('should call clearCart on the repository', () async {
    // Given
    when(mockRepository.clearCart(any)).thenAnswer((_) async => {});

    // When
    await useCase.execute(false);

    // Then
    verify(mockRepository.clearCart(false)).called(1);
  });

  test('should call clearCart with true when isExpress is true', () async {
    // Given
    when(mockRepository.clearCart(any)).thenAnswer((_) async => {});

    // When
    await useCase.execute(true);

    // Then
    verify(mockRepository.clearCart(true)).called(1);
  });
}
