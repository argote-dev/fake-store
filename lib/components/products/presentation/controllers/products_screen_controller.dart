import 'package:fake_store/components/products/domain/models/product.dart';
import 'package:fake_store/components/products/presentation/controllers/state/products_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/products_provider.dart';

class ProductsScreenController extends Notifier<ProductsScreenState> {
  final String categoryName;

  ProductsScreenController(this.categoryName);

  @override
  ProductsScreenState build() {
    Future.microtask(() => loadProducts());
    return ProductsScreenState();
  }

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await ref
        .read(getProductsByCategoryUseCaseProvider)
        .execute(categoryName);

    result.when(
      success: (products) {
        state = state.copyWith(
          allProducts: products,
          filteredProducts: _filterProducts(products, state.searchQuery),
          isLoading: false,
        );
      },
      failure: (exception) {
        state = state.copyWith(isLoading: false, error: exception.toString());
      },
    );
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(
      searchQuery: query,
      filteredProducts: _filterProducts(state.allProducts, query),
    );
  }

  List<Product> _filterProducts(List<Product> products, String query) {
    if (query.isEmpty) return products;
    return products
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

final productsScreenController =
    NotifierProvider.family<
      ProductsScreenController,
      ProductsScreenState,
      String
    >(ProductsScreenController.new);
