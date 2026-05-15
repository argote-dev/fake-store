import 'package:fake_store/components/products/data/datasources/local/products_local_data_source.dart';
import 'package:fake_store/components/products/data/models/entity/product_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'products_local_data_source_test.mocks.dart';

@GenerateMocks([Database, Batch])
void main() {
  late MockDatabase mockDatabase;
  late MockBatch mockBatch;
  late ProductsLocalDataSourceImpl dataSource;

  setUp(() {
    mockDatabase = MockDatabase();
    mockBatch = MockBatch();
    dataSource = ProductsLocalDataSourceImpl(database: mockDatabase);
  });

  group('ProductsLocalDataSource', () {
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

    test('getProducts should return list of ProductEntity from database', () async {
      // Given
      final tMap = [tProductEntity.toMap()];
      when(mockDatabase.query(any)).thenAnswer((_) async => tMap);

      // When
      final result = await dataSource.getProducts();

      // Then
      expect(result.length, 1);
      expect(result.first.productId, 1);
      verify(mockDatabase.query('products'));
    });

    test('saveProducts should insert products using a batch', () async {
      // Given
      when(mockDatabase.batch()).thenReturn(mockBatch);
      when(mockBatch.commit(noResult: anyNamed('noResult')))
          .thenAnswer((_) async => []);

      // When
      await dataSource.saveProducts([tProductEntity]);

      // Then
      verify(mockDatabase.batch());
      verify(mockBatch.insert(
        'products',
        tProductEntity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      ));
      verify(mockBatch.commit(noResult: true));
    });

    test('clearProducts should delete all records from the table', () async {
      // Given
      when(mockDatabase.delete(any)).thenAnswer((_) async => 1);

      // When
      await dataSource.clearProducts();

      // Then
      verify(mockDatabase.delete('products'));
    });
  });
}
