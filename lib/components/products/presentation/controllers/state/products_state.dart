import 'package:fake_store/components/products/domain/models/product.dart';

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
