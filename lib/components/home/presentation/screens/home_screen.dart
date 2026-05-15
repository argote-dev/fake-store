import 'package:flutter/material.dart';
import 'package:fake_store/common/l10n/app_localizations.dart';
import '../../../../ui/widgets/atoms/section_title.dart';
import '../../../../ui/widgets/molecules/search_top_bar.dart';
import '../../../categories/presentation/widgets/organisms/category_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        children: [
          const SearchTopBar(),
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
