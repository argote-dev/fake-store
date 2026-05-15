import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/product.dart';
import '../../data/providers/products_provider.dart';

class ProductsScreenState {
  final List<Product> allProducts;
  final List<Product> filteredProducts;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  ProductsScreenState({
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.isLoading = true,
    this.error,
    this.searchQuery = '',
  });

  ProductsScreenState copyWith({
    List<Product>? allProducts,
    List<Product>? filteredProducts,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return ProductsScreenState(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ProductsScreenNotifier extends Notifier<ProductsScreenState> {
  final String categoryName;

  ProductsScreenNotifier(this.categoryName);

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

final productsScreenProvider =
    NotifierProvider.family<
      ProductsScreenNotifier,
      ProductsScreenState,
      String
    >(ProductsScreenNotifier.new);
