import 'package:flutter/material.dart';
import 'package:fake_store/common/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../shopping_cart_presentation.dart';
import '../../../../common/utils/currency_formatter.dart';

class ShoppingCartScreen extends ConsumerWidget {
  const ShoppingCartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isExpressMode = ref.watch(expressModeProvider);
    final cartItems = ref.watch(shoppingCartProvider(isExpressMode));
    final controller = ref.read(shoppingCartProvider(isExpressMode).notifier);

    final themeColor = isExpressMode
        ? const Color(0xFF2596be)
        : const Color(0xFFFFe800);
    final foregroundColor = isExpressMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isExpressMode ? l10n.cartTitleExpress : l10n.cartTitleStandard,
        ),
        backgroundColor: themeColor,
        foregroundColor: foregroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: foregroundColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: cartItems.isEmpty
          ? Center(child: Text(l10n.emptyCartMessage))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        leading: Image.network(
                          item.image,
                          width: 50,
                          height: 50,
                          errorBuilder: (_, _, _) => const Icon(Icons.image),
                        ),
                        title: Text(item.name),
                        subtitle: Text(
                          '${CurrencyFormatter.formatCOP(item.price)} x ${item.quantity} ${l10n.unitsLabel}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              color: Colors.black,
                              onPressed: () => controller.updateQuantity(
                                item.productId,
                                item.quantity - 1,
                              ),
                            ),
                            Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              color: Colors.black,
                              onPressed: () => controller.updateQuantity(
                                item.productId,
                                item.quantity + 1,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.totalLabel,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.formatCOP(
                              cartItems.fold(
                                0.0,
                                (sum, item) =>
                                    sum + (item.price * item.quantity),
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext dialogContext) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    bool isProcessing = true;

                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      if (context.mounted && isProcessing) {
                                        setState(() {
                                          isProcessing = false;
                                        });

                                        Future.delayed(
                                            const Duration(milliseconds: 1000),
                                            () {
                                          if (context.mounted) {
                                            Navigator.of(dialogContext).pop();
                                            controller.clearCart();
                                            context.go('/');
                                          }
                                        });
                                      }
                                    });

                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isProcessing) ...[
                                            const CircularProgressIndicator(),
                                            const SizedBox(height: 16),
                                            const Text('Procesando pago...'),
                                          ] else ...[
                                            const Icon(Icons.check_circle,
                                                color: Colors.green, size: 48),
                                            const SizedBox(height: 16),
                                            const Text('Pago realizado'),
                                          ],
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            foregroundColor: foregroundColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(l10n.checkoutButton),
                        ),
                      ),
                      const SizedBox(height: 16), // Bottom margin
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
