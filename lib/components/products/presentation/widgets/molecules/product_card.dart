import 'package:flutter/material.dart';
import 'package:fake_store/common/l10n/app_localizations.dart';
import 'package:fake_store/ui/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/utils/currency_formatter.dart';
import '../../../../shopping_cart/presentation/controllers/express_mode_controller.dart';
import '../../../../shopping_cart/presentation/controllers/shopping_cart_controller.dart';
import '../../../domain/models/product.dart';
import '../atoms/product_add_button.dart';
import '../atoms/product_quantity_control.dart';

class ProductCard extends ConsumerWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isExpressMode = ref.watch(expressModeProvider);

    final cartAsync = ref.watch(shoppingCartProvider(isExpressMode));
    final cartItems = cartAsync.value ?? [];

    final cartController = ref.read(
      shoppingCartProvider(isExpressMode).notifier,
    );

    final cartItem = cartItems
        .where((item) => item.productId == product.productId)
        .firstOrNull;
    final isInCart = cartItem != null;

    final themeColor = isExpressMode
        ? AppColors.expressModeBlue
        : AppColors.regularModeYellow;
    final foregroundColor = isExpressMode ? Colors.white : Colors.black;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _ProductImage(imageUrl: product.image),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProductTitle(name: product.name),
                const SizedBox(height: 4),
                _ProductUnit(unit: product.unit),
                const SizedBox(height: 12),
                _ProductPrice(price: product.price),
                const SizedBox(height: 12),
                _buildActions(
                  context,
                  isExpressMode,
                  isInCart,
                  cartItem?.quantity ?? 0,
                  cartController,
                  l10n,
                  themeColor,
                  foregroundColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    bool isExpressMode,
    bool isInCart,
    int quantity,
    ShoppingCartController cartController,
    AppLocalizations l10n,
    Color themeColor,
    Color foregroundColor,
  ) {
    if (!isExpressMode) {
      if (!isInCart) {
        return ProductAddButton(
          label: l10n.addButton,
          backgroundColor: AppColors.orange,
          foregroundColor: Colors.white,
          onPressed: () => cartController.addProduct(product),
        );
      }
      return ProductQuantityControl(
        quantity: quantity,
        unitLabel: l10n.unitsLabel,
        onIncrement: () =>
            cartController.updateQuantity(product.productId, quantity + 1),
        onDecrement: () =>
            cartController.updateQuantity(product.productId, quantity - 1),
      );
    } else {
      return Column(
        children: [
          ProductAddButton(
            label: l10n.buyButton,
            backgroundColor: themeColor,
            foregroundColor: foregroundColor,
            suffixIcon: Icons.shopping_cart_outlined,
            onPressed: () {
              cartController.addProduct(product);
              context.push('/cart');
            },
          ),
          const SizedBox(height: 8),
          ProductQuantityControl(
            quantity: quantity,
            unitLabel: l10n.unitsLabel,
            isExpress: true,
            onIncrement: () => cartController.addProduct(product),
            onDecrement: () {
              if (isInCart) {
                cartController.updateQuantity(product.productId, quantity - 1);
              }
            },
          ),
        ],
      );
    }
  }
}

class _ProductImage extends StatelessWidget {
  final String imageUrl;

  const _ProductImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

class _ProductTitle extends StatelessWidget {
  final String name;

  const _ProductTitle({required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _ProductUnit extends StatelessWidget {
  final String unit;

  const _ProductUnit({required this.unit});

  @override
  Widget build(BuildContext context) {
    return Text(
      unit,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: AppColors.grey),
    );
  }
}

class _ProductPrice extends StatelessWidget {
  final double price;

  const _ProductPrice({required this.price});

  @override
  Widget build(BuildContext context) {
    return Text(
      CurrencyFormatter.formatCOP(price),
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppColors.darkRed,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
