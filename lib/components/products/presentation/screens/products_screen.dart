import 'package:fake_store/components/products/presentation/controllers/state/products_state.dart';
import 'package:flutter/material.dart';
import 'package:fake_store/common/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:fake_store/ui/ui.dart';
import '../../../categories/domain/models/category.dart';
import '../../../shopping_cart/presentation/shopping_cart_presentation.dart';
import '../controllers/products_screen_controller.dart';
import '../widgets/molecules/product_card.dart';

class ProductsScreen extends ConsumerWidget {
  final Category category;

  const ProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(productsScreenController(category.name));
    final controller = ref.read(productsScreenController(category.name).notifier);
    final isExpressMode = ref.watch(expressModeProvider);
    final cartItems = ref.watch(shoppingCartProvider(isExpressMode));
    final theme = Theme.of(context);

    final themeColor = isExpressMode ? const Color(0xFF2596be) : const Color(0xFFFFe800);
    final foregroundColor = isExpressMode ? Colors.white : Colors.black;

    final totalItems = cartItems.fold(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom Top Bar
          SearchTopBar(
            hintText: l10n.searchPlaceholder,
            backgroundColor: themeColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: foregroundColor),
              onPressed: () => context.pop(),
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: foregroundColor,
                    ),
                    onPressed: () => context.push('/cart'),
                  ),
                  if (totalItems > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$totalItems',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ],
            onChanged: (value) => controller.updateSearchQuery(value),
          ),

          // Category Title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              category.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Products Grid
          Expanded(child: _buildBody(context, state)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductsScreenState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(child: Text('Error: ${state.error}'));
    }

    if (state.filteredProducts.isEmpty) {
      return const Center(child: Text('No se encontraron productos.'));
    }

    return MasonryGridView.count(
      padding: const EdgeInsets.all(12),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemCount: state.filteredProducts.length,
      itemBuilder: (context, index) {
        final product = state.filteredProducts[index];
        return ProductCard(
          product: product,
        );
      },
    );
  }
}
