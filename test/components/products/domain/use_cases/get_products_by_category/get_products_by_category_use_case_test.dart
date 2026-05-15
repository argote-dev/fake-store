import 'package:fake_store/components/products/domain/models/product.dart';
import 'package:fake_store/components/products/domain/repositories/products_repository.dart';
import 'package:fake_store/components/products/domain/use_cases/get_products_by_category/get_products_by_category_use_case.dart';
import 'package:fake_store/common/models/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_products_by_category_use_case_test.mocks.dart';

@GenerateMocks([ProductsRepository])
void main() {
  provideDummy<Result<List<Product>>>(Result.failure(Exception('dummy')));

  late MockProductsRepository mockRepository;
  late GetProductsByCategoryUseCase useCase;

  setUp(() {
    mockRepository = MockProductsRepository();
    useCase = GetProductsByCategoryUseCase(mockRepository);
  });

  final tProducts = [
    Product(
      productId: 1,
      name: 'Product 1',
      description: 'Description 1',
      price: 10.0,
      unit: 'Unit',
      image: 'image',
      discount: 0,
      availability: true,
      brand: 'Brand',
      category: 'Electronics',
      rating: 4.5,
      reviews: [],
    )
  ];

  test('should call getProductsByCategory from repository', () async {
    // Given
    const tCategory = 'Electronics';
    const tLimit = 10;
    const tOffset = 0;
    when(mockRepository.getProductsByCategory(tCategory, tLimit, tOffset))
        .thenAnswer((_) async => Result.success(tProducts));

    // When
    final result = await useCase.execute(tCategory, limit: tLimit, offset: tOffset);

    // Then
    expect(result.isSuccess, true);
    result.when(
      success: (value) => expect(value, tProducts),
      failure: (error) => fail('Should be success'),
    );
    verify(mockRepository.getProductsByCategory(tCategory, tLimit, tOffset));
    verifyNoMoreInteractions(mockRepository);
  });
}
