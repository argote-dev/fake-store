import 'package:fake_store/components/products/data/models/dto/product_response.dart';
import 'package:fake_store/components/products/data/models/entity/product_entity.dart';
import 'package:fake_store/components/products/data/datasources/local/products_local_data_source.dart';
import 'package:fake_store/components/products/data/datasources/remote/products_remote_data_source.dart';
import 'package:fake_store/components/products/data/repositories/products_repository_impl.dart';
import 'package:fake_store/network/model/result/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'products_repository_impl_test.mocks.dart';

@GenerateMocks([ProductsRemoteDataSource, ProductsLocalDataSource])
void main() {
  provideDummy<Result<List<ProductResponse>>>(Result.failure(Exception('dummy')));

  late MockProductsRemoteDataSource mockRemoteDataSource;
  late MockProductsLocalDataSource mockLocalDataSource;
  late ProductsRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockProductsRemoteDataSource();
    mockLocalDataSource = MockProductsLocalDataSource();
    repository = ProductsRepositoryImpl(mockRemoteDataSource, mockLocalDataSource);
  });

  group('getProducts', () {
    final tProductEntity = ProductEntity(
      productId: 1,
      name: 'Test',
      description: 'Desc',
      price: 10.0,
      unit: 'Piece',
      image: 'img',
      discount: 0,
      availability: true,
      brand: 'Brand',
      category: 'Cat',
      rating: 4.5,
    );
    final tProductResponse = ProductResponse(
      productId: 1,
      name: 'Test',
      description: 'Desc',
      price: 10.0,
      unit: 'Piece',
      image: 'img',
      discount: 0,
      availability: true,
      brand: 'Brand',
      category: 'Cat',
      rating: 4.5,
    );

    test('should return local data when available', () async {
      // Given
      when(mockLocalDataSource.getProducts()).thenAnswer((_) async => [tProductEntity]);

      // When
      final result = await repository.getProducts();

      // Then
      expect(result.isSuccess, true);
      verify(mockLocalDataSource.getProducts());
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test('should fetch from remote and save to local when local is empty', () async {
      // Given
      when(mockLocalDataSource.getProducts()).thenAnswer((_) async => []);
      when(mockRemoteDataSource.getProducts()).thenAnswer((_) async => Result.success([tProductResponse]));
      when(mockLocalDataSource.saveProducts(any)).thenAnswer((_) async => {});

      // When
      final result = await repository.getProducts();

      // Then
      expect(result.isSuccess, true);
      verify(mockLocalDataSource.getProducts());
      verify(mockRemoteDataSource.getProducts());
      verify(mockLocalDataSource.saveProducts(any));
    });

    test('should return failure when remote fetch fails and local is empty', () async {
      // Given
      final tException = Exception('Remote failure');
      when(mockLocalDataSource.getProducts()).thenAnswer((_) async => []);
      when(mockRemoteDataSource.getProducts()).thenAnswer((_) async => Result.failure(tException));

      // When
      final result = await repository.getProducts();

      // Then
      expect(result.isFailure, true);
      verify(mockLocalDataSource.getProducts());
      verify(mockRemoteDataSource.getProducts());
      verifyNever(mockLocalDataSource.saveProducts(any));
    });
  });
}
