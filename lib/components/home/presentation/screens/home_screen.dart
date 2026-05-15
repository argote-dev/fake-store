import 'package:flutter/material.dart';
import 'package:fake_store/common/l10n/app_localizations.dart';
import 'package:fake_store/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../categories/presentation/categories_presentation.dart';
import 'package:fake_store/components/shopping_cart/presentation/controllers/express_mode_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isExpressMode = ref.watch(expressModeProvider);
    final controller = ref.read(expressModeProvider.notifier);

    return Scaffold(
      body: Column(
        children: [
          const SearchTopBar(),
          if (controller.shouldShowSwitcher)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.expressModeLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: isExpressMode,
                    onChanged: (value) => controller.toggle(value),
                  ),
                ],
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: SafeArea(
                top: false,
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(title: l10n.categoriesTitle),
                    const SizedBox(height: 12),
                    const CategoryGrid(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
