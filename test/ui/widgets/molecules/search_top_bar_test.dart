import 'package:fake_store/ui/widgets/molecules/search_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store/common/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  Widget createWidget({ValueChanged<String>? onChanged}) {
    return MaterialApp(
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
      home: Scaffold(
        body: SearchTopBar(onChanged: onChanged),
      ),
    );
  }

  testWidgets('SearchTopBar debounces onChanged callback', (WidgetTester tester) async {
    String? lastValue;
    int callCount = 0;

    await tester.pumpWidget(createWidget(
      onChanged: (value) {
        lastValue = value;
        callCount++;
      },
    ));

    // Simulate typing 'abc'
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(find.byType(TextField), 'ab');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(find.byType(TextField), 'abc');

    // Callback should not have been called yet
    expect(callCount, 0);

    // Wait for the debounce time (300ms)
    await tester.pump(const Duration(milliseconds: 300));

    expect(callCount, 1);
    expect(lastValue, 'abc');
  });
}
