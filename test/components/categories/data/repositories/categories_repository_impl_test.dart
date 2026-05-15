import 'package:fake_store/components/categories/data/datasources/local/categories_local_data_source.dart';
import 'package:fake_store/components/categories/data/models/entity/category_entity.dart';
import 'package:fake_store/components/categories/data/repositories/categories_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'categories_repository_impl_test.mocks.dart';

@GenerateMocks([CategoriesLocalDataSource])
void main() {
  late MockCategoriesLocalDataSource mockLocalDataSource;
  late CategoriesRepositoryImpl repository;

  setUp(() {
    mockLocalDataSource = MockCategoriesLocalDataSource();
    repository = CategoriesRepositoryImpl(mockLocalDataSource);
  });

  group('getCategories', () {
    final tCategoryEntities = [
      CategoryEntity(id: 1, name: 'Electronics'),
      CategoryEntity(id: 2, name: 'Wearables'),
    ];

    test('should return list of categories when local fetch is successful', () async {
      // Given
      when(mockLocalDataSource.getCategories())
          .thenAnswer((_) async => tCategoryEntities);

      // When
      final result = await repository.getCategories();

      // Then
      expect(result.isSuccess, true);
      result.when(
        success: (categories) {
          expect(categories.length, 2);
          expect(categories[0].name, 'Electronics');
          expect(categories[1].name, 'Wearables');
        },
        failure: (error) => fail('Should not fail'),
      );
      verify(mockLocalDataSource.getCategories());
    });

    test('should return failure when local fetch throws exception', () async {
      // Given
      when(mockLocalDataSource.getCategories()).thenThrow(Exception('Database error'));

      // When
      final result = await repository.getCategories();

      // Then
      expect(result.isFailure, true);
      verify(mockLocalDataSource.getCategories());
    });
  });
}
