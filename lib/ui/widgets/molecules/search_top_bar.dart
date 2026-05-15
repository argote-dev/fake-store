import 'package:flutter/material.dart';
import '../../../common/l10n/app_localizations.dart';
import '../../../common/utils/debouncer.dart';

class SearchTopBar extends StatefulWidget {
  final String? hintText;
  final Widget? leading;
  final List<Widget>? actions;
  final ValueChanged<String>? onChanged;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const SearchTopBar({
    super.key,
    this.hintText,
    this.leading,
    this.actions,
    this.onChanged,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  State<SearchTopBar> createState() => _SearchTopBarState();
}

class _SearchTopBarState extends State<SearchTopBar> {
  late final Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(milliseconds: 300);
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final bgColor = widget.backgroundColor ?? theme.primaryColor;

    return Container(
      color: bgColor,
      padding: EdgeInsets.only(
        left: 12.0,
        right: 12.0,
        bottom: 8.0,
        top: MediaQuery.of(context).padding.top + 8.0,
      ),
      child: Row(
        children: [
          if (widget.leading != null) ...[
            widget.leading!,
            const SizedBox(width: 8),
          ],
          Expanded(
            child: TextField(
              onChanged: (value) {
                _debouncer.run(() {
                  widget.onChanged?.call(value);
                });
              },
              style: const TextStyle(
                color: Colors.black,
              ), // Text always black on white field
              decoration: InputDecoration(
                hintText: widget.hintText ?? l10n.searchHint,
                hintStyle: TextStyle(
                  color: Colors.black.withValues(alpha: 0.5),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.black,
                ),
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
          if (widget.actions != null && widget.actions!.isNotEmpty) ...[
            const SizedBox(width: 8),
            ...widget.actions!,
          ],
        ],
      ),
    );
  }
}
