import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/categories_provider.dart';

final categoriesController = FutureProvider((ref) async {
  final useCase = ref.watch(getCategoriesUseCaseProvider);
  final result = await useCase.execute();
  return result.when(
    success: (categories) => categories,
    failure: (error) => throw error,
  );
});
