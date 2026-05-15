import 'package:flutter/material.dart';
import 'package:fake_store/ui/theme/app_colors.dart';

class ProductQuantityControl extends StatelessWidget {
  final int quantity;
  final String unitLabel;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isExpress;

  const ProductQuantityControl({
    super.key,
    required this.quantity,
    required this.unitLabel,
    required this.onIncrement,
    required this.onDecrement,
    this.isExpress = false,
  });

  @override
  Widget build(BuildContext context) {
    final minusIcon = isExpress
        ? Icons.delete_outline
        : Icons.remove_circle_outline;
    
    final minusColor = isExpress ? Colors.black : AppColors.orange;
    final plusColor = isExpress ? AppColors.expressModeBlue : AppColors.orange;

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            key: const ValueKey('quantity_decrement_button'),
            onPressed: onDecrement,
            icon: Icon(minusIcon, size: 18, color: minusColor),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Text(
            '$quantity $unitLabel',
            key: const ValueKey('quantity_text'),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.black,
            ),
          ),
          IconButton(
            key: const ValueKey('quantity_increment_button'),
            onPressed: onIncrement,
            icon: Icon(Icons.add_circle_outline, size: 18, color: plusColor),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
