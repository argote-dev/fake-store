import 'package:flutter/material.dart';
import 'package:fake_store/common/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/utils/currency_formatter.dart';
import '../../../../shopping_cart/presentation/controllers/express_mode_controller.dart';
import '../../../../shopping_cart/presentation/controllers/shopping_cart_controller.dart';
import '../../../domain/models/product.dart';

class ProductCard extends ConsumerWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isExpressMode = ref.watch(expressModeProvider);
    final cartItems = ref.watch(shoppingCartProvider(isExpressMode));
    final cartController = ref.read(shoppingCartProvider(isExpressMode).notifier);

    final cartItem = cartItems.where((item) => item.productId == product.productId).firstOrNull;
    final isInCart = cartItem != null;

    final themeColor = isExpressMode ? const Color(0xFF2596be) : const Color(0xFFFFe800);
    final foregroundColor = isExpressMode ? Colors.white : Colors.black;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  product.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Units
                Text(
                  product.unit,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                // Price
                Text(
                  CurrencyFormatter.formatCOP(product.price),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF8B0000), // Dark Red
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                // Buttons
                if (!isExpressMode) ...[
                  if (!isInCart)
                    _buildAddButton(
                      label: l10n.addButton,
                      color: Colors.orange,
                      textColor: Colors.white,
                      onPressed: () => cartController.addProduct(product),
                    )
                  else
                    _buildQuantityControl(
                      quantity: cartItem.quantity,
                      onIncrement: () => cartController.updateQuantity(product.productId, cartItem.quantity + 1),
                      onDecrement: () => cartController.updateQuantity(product.productId, cartItem.quantity - 1),
                      l10n: l10n,
                      isExpress: false,
                    ),
                ] else ...[
                  _buildAddButton(
                    label: l10n.buyButton,
                    color: themeColor,
                    textColor: foregroundColor,
                    suffixIcon: Icons.shopping_cart_outlined,
                    onPressed: () {
                      cartController.addProduct(product);
                      context.push('/cart');
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildQuantityControl(
                    quantity: cartItem?.quantity ?? 0,
                    onIncrement: () => cartController.addProduct(product),
                    onDecrement: () {
                      if (isInCart) {
                        cartController.updateQuantity(product.productId, cartItem.quantity - 1);
                      }
                    },
                    isExpress: true,
                    l10n: l10n,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
    IconData? suffixIcon,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 36,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            if (suffixIcon != null) ...[
              const SizedBox(width: 8),
              Icon(suffixIcon, size: 16),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityControl({
    required int quantity,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    required AppLocalizations l10n,
    bool isExpress = false,
  }) {
    final minusIcon = isExpress ? Icons.delete_outline : Icons.remove;
    final minusColor = isExpress ? Colors.black : Colors.orange;
    final plusColor = isExpress ? const Color(0xFF2596be) : Colors.orange;
    final textColor = Colors.black;

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFf1f1f1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onDecrement,
            icon: Icon(minusIcon, size: 18, color: minusColor),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Text(
            '$quantity ${l10n.unitsLabel}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: textColor,
            ),
          ),
          IconButton(
            onPressed: onIncrement,
            icon: Icon(Icons.add, size: 18, color: plusColor),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
