import 'package:flutter/material.dart';
import '../../../common/l10n/app_localizations.dart';

class SearchTopBar extends StatelessWidget {
  final String? hintText;
  final Widget? leading;
  final List<Widget>? actions;
  final ValueChanged<String>? onChanged;

  const SearchTopBar({
    super.key,
    this.hintText,
    this.leading,
    this.actions,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      color: theme.primaryColor,
      padding: EdgeInsets.only(
        left: 12.0,
        right: 12.0,
        bottom: 8.0,
        top: MediaQuery.of(context).padding.top + 8.0,
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 8),
          ],
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: const TextStyle(color: Colors.black), // Text always black on white field
              decoration: InputDecoration(
                hintText: hintText ?? l10n.searchHint,
                hintStyle: TextStyle(color: Colors.black.withValues(alpha: 0.5)),
                prefixIcon: const Icon(Icons.search, size: 20, color: Colors.black),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          if (actions != null && actions!.isNotEmpty) ...[
            const SizedBox(width: 8),
            ...actions!,
          ],
        ],
      ),
    );
  }
}
