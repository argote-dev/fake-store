import 'package:fake_store/components/products/domain/models/product.dart';
import 'package:fake_store/components/products/domain/repositories/products_repository.dart';
import 'package:fake_store/components/products/domain/use_cases/get_products/get_products_use_case.dart';
import 'package:fake_store/network/model/result/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_products_use_case_test.mocks.dart';

@GenerateMocks([ProductsRepository])
void main() {
  provideDummy<Result<List<Product>>>(Result.failure(Exception('dummy')));

  late MockProductsRepository mockRepository;
  late GetProductsUseCase useCase;

  setUp(() {
    mockRepository = MockProductsRepository();
    useCase = GetProductsUseCase(mockRepository);
  });

  group('GetProductsUseCase', () {
    final tProducts = [
      Product(
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
      ),
    ];

    test('should get products from the repository', () async {
      // Given
      when(mockRepository.getProducts())
          .thenAnswer((_) async => Result.success(tProducts));

      // When
      final result = await useCase.execute();

      // Then
      expect(result.isSuccess, true);
      result.when(
        success: (value) => expect(value, tProducts),
        failure: (error) => fail('Should be success'),
      );
      verify(mockRepository.getProducts());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when the repository fails', () async {
      // Given
      final tException = Exception('Repository error');
      when(mockRepository.getProducts())
          .thenAnswer((_) async => Result.failure(tException));

      // When
      final result = await useCase.execute();

      // Then
      expect(result.isFailure, true);
      verify(mockRepository.getProducts());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
