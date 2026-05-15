import 'package:fake_store/components/products/data/datasources/remote/products_remote_data_source.dart';
import 'package:fake_store/common/models/result.dart';
import 'package:fake_store/network/router/network_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'products_remote_data_source_test.mocks.dart';

@GenerateMocks([NetworkRouter])
void main() {
  provideDummy<Result<dynamic>>(Result.failure(Exception('dummy')));

  late MockNetworkRouter mockRouter;
  late ProductsRemoteDataSourceImpl dataSource;

  setUp(() {
    mockRouter = MockNetworkRouter();
    dataSource = ProductsRemoteDataSourceImpl(mockRouter);
  });

  group('getProducts', () {
    final tProductJson = [
      {
        "product_id": 1,
        "name": "Smartphone",
        "description": "High-end smartphone",
        "price": 599.99,
        "unit": "Piece",
        "image": "url",
        "discount": 10,
        "availability": true,
        "brand": "BrandX",
        "category": "Electronics",
        "rating": 4.5
      }
    ];

    test('should return List<ProductResponse> when the call is successful', () async {
      // Given
      when(mockRouter.fetch<dynamic>(any))
          .thenAnswer((_) async => Result.success(tProductJson));

      // When
      final result = await dataSource.getProducts();

      // Then
      expect(result.isSuccess, true);
      result.when(
        success: (value) {
          expect(value.length, 1);
          expect(value.first.productId, 1);
          expect(value.first.name, "Smartphone");
        },
        failure: (_) => fail('Should be success'),
      );
      verify(mockRouter.fetch<dynamic>(any));
    });

    test('should return failure when the call fails', () async {
      // Given
      final tException = Exception('Network error');
      when(mockRouter.fetch<dynamic>(any))
          .thenAnswer((_) async => Result.failure(tException));

      // When
      final result = await dataSource.getProducts();

      // Then
      expect(result.isFailure, true);
      verify(mockRouter.fetch<dynamic>(any));
    });
  });
}
