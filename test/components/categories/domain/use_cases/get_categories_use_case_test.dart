import 'package:fake_store/components/categories/domain/models/category.dart';
import 'package:fake_store/components/categories/domain/repositories/categories_repository.dart';
import 'package:fake_store/components/categories/domain/use_cases/get_categories/get_categories_use_case.dart';
import 'package:fake_store/network/model/result/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_categories_use_case_test.mocks.dart';

@GenerateMocks([CategoriesRepository])
void main() {
  provideDummy<Result<List<Category>>>(Result.failure(Exception('dummy')));

  late MockCategoriesRepository mockRepository;
  late GetCategoriesUseCase useCase;

  setUp(() {
    mockRepository = MockCategoriesRepository();
    useCase = GetCategoriesUseCase(mockRepository);
  });

  group('execute', () {
    final tCategories = [
      Category(id: 1, name: 'Electronics', image: 'assets/images/electronics.jpg'),
      Category(id: 2, name: 'Wearables', image: 'assets/images/wearable.jpg'),
    ];

    test('should return list of categories from repository', () async {
      // Given
      when(mockRepository.getCategories())
          .thenAnswer((_) async => Result.success(tCategories));

      // When
      final result = await useCase.execute();

      // Then
      expect(result.isSuccess, true);
      result.when(
        success: (categories) => expect(categories, tCategories),
        failure: (error) => fail('Should not fail'),
      );
      verify(mockRepository.getCategories());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // Given
      final tException = Exception('Failed to get categories');
      when(mockRepository.getCategories())
          .thenAnswer((_) async => Result.failure(tException));

      // When
      final result = await useCase.execute();

      // Then
      expect(result.isFailure, true);
      verify(mockRepository.getCategories());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
