import 'package:fake_store/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createTestWidget(Widget Function(BuildContext context) builder) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: builder,
        ),
      ),
    );
  }

  testWidgets('showAlertDialog displays title, message, and calls onOk', (WidgetTester tester) async {
    bool okCalled = false;

    await tester.pumpWidget(
      createTestWidget((context) => ElevatedButton(
            onPressed: () {
              context.showAlertDialog(
                title: 'Alert Title',
                message: 'Alert Message',
                okLabel: 'Entendido',
                onOk: () => okCalled = true,
              );
            },
            child: const Text('Show Alert'),
          )),
    );

    // Tap button to open dialog
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify dialog content
    expect(find.text('Alert Title'), findsOneWidget);
    expect(find.text('Alert Message'), findsOneWidget);
    expect(find.text('Entendido'), findsOneWidget);

    // Tap OK button
    await tester.tap(find.text('Entendido'));
    await tester.pumpAndSettle();

    // Verify dialog is closed and callback was triggered
    expect(find.text('Alert Title'), findsNothing);
    expect(okCalled, isTrue);
  });

  testWidgets('showConfirmDialog returns true on confirm and false on cancel', (WidgetTester tester) async {
    bool? dialogResult;

    await tester.pumpWidget(
      createTestWidget((context) => ElevatedButton(
            onPressed: () async {
              dialogResult = await context.showConfirmDialog(
                title: 'Confirm Title',
                message: 'Confirm Message',
                confirmLabel: 'Sí',
                cancelLabel: 'No',
              );
            },
            child: const Text('Show Confirm'),
          )),
    );

    // Test Cancel flow
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('Confirm Title'), findsOneWidget);
    await tester.tap(find.text('No'));
    await tester.pumpAndSettle();

    expect(dialogResult, isFalse);
    expect(find.text('Confirm Title'), findsNothing);

    // Test Confirm flow
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sí'));
    await tester.pumpAndSettle();

    expect(dialogResult, isTrue);
    expect(find.text('Confirm Title'), findsNothing);
  });

  testWidgets('showLoadingDialog displays and can be closed using returned callback', (WidgetTester tester) async {
    late void Function() closeDialog;

    await tester.pumpWidget(
      createTestWidget((context) => ElevatedButton(
            onPressed: () {
              closeDialog = context.showLoadingDialog(message: 'Espere por favor...');
            },
            child: const Text('Show Loading'),
          )),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Start opening transition
    await tester.pump(const Duration(seconds: 1)); // Settle dialog

    // Verify loading dialog is shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Espere por favor...'), findsOneWidget);

    // Close using the returned callback
    closeDialog();
    await tester.pumpAndSettle();

    // Verify loading dialog is closed
    expect(find.text('Espere por favor...'), findsNothing);
  });

  testWidgets('showCustomDialog displays custom content and custom actions', (WidgetTester tester) async {
    String? dialogResult;

    await tester.pumpWidget(
      createTestWidget((context) => ElevatedButton(
            onPressed: () async {
              dialogResult = await context.showCustomDialog<String>(
                title: 'Custom Title',
                content: const Text('Custom Content'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop('Option A'),
                    child: const Text('Btn A'),
                  ),
                ],
              );
            },
            child: const Text('Show Custom'),
          )),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('Custom Title'), findsOneWidget);
    expect(find.text('Custom Content'), findsOneWidget);
    expect(find.text('Btn A'), findsOneWidget);

    await tester.tap(find.text('Btn A'));
    await tester.pumpAndSettle();

    expect(dialogResult, 'Option A');
    expect(find.text('Custom Title'), findsNothing);
  });
}
