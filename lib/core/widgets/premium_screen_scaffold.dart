import 'package:flutter/material.dart';

import '../theme/layout_tokens.dart';

class PremiumScreenScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final Widget? leading;
  final List<Widget> trailing;
  final bool includeHeader;
  final double? maxContentWidth;
  final EdgeInsets? padding;
  final Widget? topOverlay;
  final Widget? floatingContextAction;

  const PremiumScreenScaffold({
    super.key,
    required this.body,
    this.title,
    this.leading,
    this.trailing = const [],
    this.includeHeader = false,
    this.maxContentWidth,
    this.padding,
    this.topOverlay,
    this.floatingContextAction,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final density = PremiumLayout.densityForWidth(constraints.maxWidth);
        final resolvedPadding = padding ?? PremiumLayout.screenPadding(density);
        final resolvedMaxWidth = maxContentWidth ?? PremiumLayout.maxContentWidth(constraints.maxWidth);

        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: resolvedMaxWidth),
                    child: Padding(
                      padding: resolvedPadding,
                      child: Column(
                        children: [
                          if (includeHeader) ...[
                            Row(
                              children: [
                                if (leading != null) ...[
                                  leading!,
                                  const SizedBox(width: 10),
                                ],
                                Expanded(
                                  child: Text(
                                    title ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: scheme.onSurface,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                ...trailing,
                              ],
                            ),
                            const SizedBox(height: SectionGap.lg),
                          ],
                          Expanded(child: body),
                        ],
                      ),
                    ),
                  ),
                ),
                if (topOverlay != null)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: topOverlay!,
                  ),
                if (floatingContextAction != null)
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: floatingContextAction!,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
