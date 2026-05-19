import 'package:fake_store/common/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension DialogExtension on BuildContext {
  /// Shows a basic alert dialog with a title, a message, and an OK button.
  ///
  /// The [title] and [message] are required. You can customize the button label
  /// using [okLabel] and provide an [onOk] callback to be executed when the OK
  /// button is pressed.
  Future<T?> showAlertDialog<T>({
    required String title,
    required String message,
    String? okLabel,
    VoidCallback? onOk,
  }) {
    final l10n = AppLocalizations.of(this);
    return showDialog<T>(
      context: this,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onOk != null) onOk();
              },
              child: Text(okLabel ?? l10n?.dialogOk ?? 'OK'),
            ),
          ],
        );
      },
    );
  }

  /// Shows a confirmation dialog with confirm and cancel buttons.
  ///
  /// Returns a [Future] that resolves to `true` if confirmed, `false` if cancelled,
  /// or `null` if dismissed by tapping outside.
  ///
  /// Customize the buttons using [confirmLabel] and [cancelLabel], and their styling
  /// via [confirmTextColor].
  Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String? confirmLabel,
    String? cancelLabel,
    Color? confirmTextColor,
  }) {
    final l10n = AppLocalizations.of(this);
    return showDialog<bool>(
      context: this,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelLabel ?? l10n?.dialogCancel ?? 'Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                confirmLabel ?? l10n?.dialogConfirm ?? 'Confirm',
                style: TextStyle(
                  color:
                      confirmTextColor ?? Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Shows a non-dismissible loading dialog, useful for blocking asynchronous processes.
  ///
  /// Returns a callback function that closes the dialog when invoked.
  void Function() showLoadingDialog({String? message}) {
    final l10n = AppLocalizations.of(this);
    final displayMessage = message ?? l10n?.dialogLoading ?? 'Loading...';
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            content: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 24),
                Expanded(
                  child: Text(
                    displayMessage,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return () {
      if (Navigator.of(this).canPop()) {
        Navigator.of(this).pop();
      }
    };
  }

  /// Shows a dialog with custom content and actions in a simplified way.
  ///
  /// Displays the provided [content] inside an [AlertDialog] with optional [title]
  /// and [actions].
  Future<T?> showCustomDialog<T>({
    required Widget content,
    String? title,
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title != null ? Text(title) : null,
          content: content,
          actions: actions,
        );
      },
    );
  }
}
