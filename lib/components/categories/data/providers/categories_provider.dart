import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/categories_repository.dart';
import '../../domain/use_cases/get_categories/get_categories_use_case.dart';
import '../datasources/local/categories_local_data_source.dart';
import '../repositories/categories_repository_impl.dart';

final categoriesLocalDataSourceProvider = Provider<CategoriesLocalDataSource>((ref) {
  return CategoriesLocalDataSourceImpl();
});

final categoriesRepositoryProvider = Provider<CategoriesRepository>((ref) {
  final local = ref.watch(categoriesLocalDataSourceProvider);
  return CategoriesRepositoryImpl(local);
});

final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) {
  final repository = ref.watch(categoriesRepositoryProvider);
  return GetCategoriesUseCase(repository);
});

final categoriesListProvider = FutureProvider((ref) async {
  final useCase = ref.watch(getCategoriesUseCaseProvider);
  final result = await useCase.execute();
  return result.when(
    success: (categories) => categories,
    failure: (error) => throw error,
  );
});
