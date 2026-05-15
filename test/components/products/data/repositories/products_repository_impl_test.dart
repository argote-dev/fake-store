import 'package:fake_store/components/products/data/models/dto/product_response.dart';
import 'package:fake_store/components/products/data/models/entity/product_entity.dart';
import 'package:fake_store/components/products/data/datasources/local/products_local_data_source.dart';
import 'package:fake_store/components/products/data/datasources/remote/products_remote_data_source.dart';
import 'package:fake_store/components/products/data/repositories/products_repository_impl.dart';
import 'package:fake_store/common/models/result.dart';
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

  group('getProductsByCategory', () {
    const tCategory = 'Electronics';
    const tLimit = 10;
    const tOffset = 0;
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
      category: tCategory,
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
      category: tCategory,
      rating: 4.5,
    );

    test('should return local data when available', () async {
      // Given
      when(mockLocalDataSource.getProductsByCategory(tCategory, tLimit, tOffset))
          .thenAnswer((_) async => [tProductEntity]);

      // When
      final result = await repository.getProductsByCategory(tCategory, tLimit, tOffset);

      // Then
      expect(result.isSuccess, true);
      verify(mockLocalDataSource.getProductsByCategory(tCategory, tLimit, tOffset));
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test('should fetch all remote, cache, and re-query local when local is empty and offset 0', () async {
      // Given
      when(mockLocalDataSource.getProductsByCategory(tCategory, tLimit, tOffset))
          .thenAnswer((_) async => []); // First call
      
      when(mockRemoteDataSource.getProducts())
          .thenAnswer((_) async => Result.success([tProductResponse]));
      when(mockLocalDataSource.saveProducts(any)).thenAnswer((_) async => {});
      
      // We need to re-stub to return data for the second call
      // or use a smarter way. Mockito.when(..).thenAnswer(..).thenAnswer(..)
      when(mockLocalDataSource.getProductsByCategory(tCategory, tLimit, tOffset))
          .thenAnswer((_) async => []); // Reset for safety
          
      // Actually, let's use a counter or just re-stub before the second call happens.
      // But they are both in the same 'repository.getProductsByCategory' call.
      
      // Let's use chained thenAnswer if supported or just return based on a flag.
      var callCount = 0;
      when(mockLocalDataSource.getProductsByCategory(tCategory, tLimit, tOffset))
          .thenAnswer((_) async {
            if (callCount == 0) {
              callCount++;
              return [];
            }
            return [tProductEntity];
          });

      // When
      final result = await repository.getProductsByCategory(tCategory, tLimit, tOffset);

      // Then
      expect(result.isSuccess, true);
      verify(mockLocalDataSource.getProductsByCategory(tCategory, tLimit, tOffset)).called(2);
      verify(mockRemoteDataSource.getProducts());
      verify(mockLocalDataSource.saveProducts(any));
    });
  });
}
