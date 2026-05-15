import 'package:fake_store/components/home/presentation/screens/home_screen.dart';
import 'package:fake_store/components/categories/presentation/controllers/categories_controller.dart';
import 'package:fake_store/components/categories/domain/models/category.dart';
import 'package:fake_store/ui/widgets/molecules/search_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: implementation_imports
import 'package:riverpod/src/framework.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store/common/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  Widget createWidget({List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('es', ''),
        ],
        home: const HomeScreen(),
      ),
    );
  }

  group('HomeScreen Widget Tests', () {
    testWidgets('should render SearchTopBar and categories title', (WidgetTester tester) async {
      // Given
      await tester.pumpWidget(createWidget(
        overrides: [
          categoriesController.overrideWith((ref) => <Category>[]),
        ],
      ));

      // When
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(SearchTopBar), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget); // Default EN locale
    });

    testWidgets('should render correctly even if express switcher is not shown', (WidgetTester tester) async {
      // Given
      await tester.pumpWidget(createWidget(
        overrides: [
          categoriesController.overrideWith((ref) => <Category>[]),
        ],
      ));

      // When
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
