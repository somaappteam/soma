import 'package:flutter/material.dart';
import 'package:soma/core/theme/tokens.dart';
import 'package:soma/core/widgets/glass.dart';
import 'package:soma/data/languages.dart';

class LanguagePickerSheet extends StatefulWidget {
  final String title;
  final String searchHint;
  final String noMatchesText;
  final List<LangOption> items;
  final LangOption current;
  final bool darkModeStyle;

  const LanguagePickerSheet({
    super.key,
    required this.title,
    required this.searchHint,
    required this.noMatchesText,
    required this.items,
    required this.current,
    this.darkModeStyle = false,
  });

  @override
  State<LanguagePickerSheet> createState() => _LanguagePickerSheetState();
}

class _LanguagePickerSheetState extends State<LanguagePickerSheet> {
  final FocusNode _searchFocus = FocusNode();
  String _query = '';
  bool _showSearch = false;

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    final nextShow = !_showSearch;
    setState(() {
      _showSearch = nextShow;
      if (!nextShow) _query = '';
    });
    if (nextShow) {
      WidgetsBinding.instance.addPostFrameCallback((final _) {
        if (mounted) _searchFocus.requestFocus();
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final normalized = _query.trim().toLowerCase();
    final filtered = normalized.isEmpty
        ? widget.items
        : widget.items
            .where((final e) => e.name.toLowerCase().contains(normalized) || e.code.toLowerCase().contains(normalized))
            .toList();
    final maxHeight = MediaQuery.of(context).size.height * 0.75;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        child: Glass(
          radius: BorderRadius.circular(26),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: SizedBox(
            height: maxHeight,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
              children: [
                Row(
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: widget.darkModeStyle ? Colors.white : scheme.onSurface,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _toggleSearch,
                      icon: Icon(
                        _showSearch ? Icons.search_off_rounded : Icons.search_rounded,
                        color: (widget.darkModeStyle ? Colors.white : scheme.onSurface).withValues(alpha: 0.85),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close_rounded,
                        color: (widget.darkModeStyle ? Colors.white : scheme.onSurface).withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_showSearch) ...[
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: widget.darkModeStyle
                          ? T.fieldFill
                          : Theme.of(context).brightness == Brightness.light
                              ? scheme.onSurface.withValues(alpha: 0.08)
                              : T.fieldFill,
                      border: Border.all(
                        color: (widget.darkModeStyle ? Colors.white : scheme.onSurface)
                            .withValues(alpha: widget.darkModeStyle ? 0.12 : 0.2),
                      ),
                    ),
                    child: TextField(
                      focusNode: _searchFocus,
                      autofocus: true,
                      onChanged: (final v) => setState(() => _query = v),
                      style: TextStyle(
                        color: widget.darkModeStyle ? Colors.white : scheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                      cursorColor: widget.darkModeStyle ? Colors.white : scheme.primary,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: widget.searchHint,
                        hintStyle: TextStyle(
                          color: (widget.darkModeStyle ? Colors.white : scheme.onSurface).withValues(alpha: 0.5),
                        ),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: (widget.darkModeStyle ? Colors.white : scheme.onSurface).withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                if (filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      widget.noMatchesText,
                      style: TextStyle(
                        color: (widget.darkModeStyle ? Colors.white : scheme.onSurface).withValues(alpha: 0.7),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                else
                  ...filtered.map((final e) {
                    final selected = e.code == widget.current.code;
                    final baseColor = widget.darkModeStyle ? Colors.white : scheme.onSurface;
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => Navigator.pop(context, e),
                      child: Container(
                        height: 52,
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: selected
                              ? (widget.darkModeStyle ? Colors.white : scheme.primary).withValues(alpha: widget.darkModeStyle ? 0.10 : 0.15)
                              : (widget.darkModeStyle ? Colors.black : scheme.onSurface).withValues(alpha: 0.10),
                          border: Border.all(
                            color: selected
                                ? (widget.darkModeStyle ? Colors.white : scheme.primary).withValues(alpha: widget.darkModeStyle ? 0.26 : 0.5)
                                : baseColor.withValues(alpha: widget.darkModeStyle ? 0.10 : 0.15),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                e.name,
                                style: TextStyle(
                                  color: widget.darkModeStyle ? Colors.white : scheme.onSurface,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            if (selected)
                              Icon(
                                Icons.check_rounded,
                                color: widget.darkModeStyle ? Colors.white.withValues(alpha: 0.9) : scheme.primary,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
