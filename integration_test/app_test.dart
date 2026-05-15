import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fake_store/main.dart' as app;
import 'package:fake_store/components/home/presentation/screens/home_screen.dart';
import 'package:fake_store/components/products/presentation/screens/products_screen.dart';
import 'package:fake_store/components/products/presentation/widgets/atoms/product_add_button.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Load environment variables once for all tests
  setUpAll(() async {
    await dotenv.load(fileName: '.env');
  });

  group('End-to-end test', () {
    testWidgets('verify home screen renders', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: app.MainApp()));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byKey(const ValueKey('categories_section_title')), findsOneWidget);
    });

    testWidgets('navigate from categories to products list', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: app.MainApp()));
      await tester.pumpAndSettle();

      final electronicsCategory = find.text('Electronics');
      await tester.scrollUntilVisible(
        electronicsCategory,
        100.0,
        scrollable: find.descendant(
          of: find.byKey(const ValueKey('home_scroll_view')),
          matching: find.byType(Scrollable),
        ).first,
      );
      await tester.pumpAndSettle();

      await tester.tap(electronicsCategory);
      await tester.pumpAndSettle();

      expect(find.byType(ProductsScreen), findsOneWidget);
      expect(find.text('Electronics'), findsOneWidget);
    });

    testWidgets('add product to cart and manage quantity', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: app.MainApp()));
      await tester.pumpAndSettle();

      final electronicsCategory = find.text('Electronics');
      await tester.scrollUntilVisible(
        electronicsCategory,
        100.0,
        scrollable: find.descendant(
          of: find.byKey(const ValueKey('home_scroll_view')),
          matching: find.byType(Scrollable),
        ).first,
      );
      await tester.pumpAndSettle();

      await tester.tap(electronicsCategory);
      await tester.pumpAndSettle();

      // Find the first product's add button and tap it
      final addButton = find.byType(ProductAddButton).first;
      await tester.tap(addButton);
      await tester.pumpAndSettle();


      final quantityText = find.byKey(const ValueKey('quantity_text'));
      expect(quantityText, findsOneWidget);
      expect(tester.widget<Text>(quantityText).data, contains('1'));

      final incrementButton = find.byKey(const ValueKey('quantity_increment_button'));
      await tester.tap(incrementButton);
      await tester.pumpAndSettle();
      expect(tester.widget<Text>(quantityText).data, contains('2'));

      final decrementButton = find.byKey(const ValueKey('quantity_decrement_button'));
      await tester.tap(decrementButton);
      await tester.pumpAndSettle();
      expect(tester.widget<Text>(quantityText).data, contains('1'));
    });
  });
}
