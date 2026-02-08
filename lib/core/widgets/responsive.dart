import 'package:flutter/material.dart';

class SomaBreakpoints {
  static const double compact = 600;
  static const double medium = 900;
  static const double wide = 1200;
}

double somaMaxWidth(double width) {
  if (width >= SomaBreakpoints.wide) return 1040;
  if (width >= SomaBreakpoints.medium) return 880;
  if (width >= SomaBreakpoints.compact) return 720;
  return width;
}

double somaGutter(double width) {
  if (width >= SomaBreakpoints.wide) return 36;
  if (width >= SomaBreakpoints.medium) return 28;
  if (width >= SomaBreakpoints.compact) return 22;
  return 16;
}

class ResponsiveFrame extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsets? padding;
  final Alignment alignment;
  final bool useGutters;

  const ResponsiveFrame({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.alignment = Alignment.topCenter,
    this.useGutters = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final resolvedMax = maxWidth ?? somaMaxWidth(width);
        final resolvedPadding = padding ??
            (useGutters
                ? EdgeInsets.symmetric(horizontal: somaGutter(width))
                : EdgeInsets.zero);

        return Align(
          alignment: alignment,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: resolvedMax),
            child: Padding(
              padding: resolvedPadding,
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class ResponsiveScroll extends StatelessWidget {
  final Widget child;
  final ScrollPhysics? physics;
  final EdgeInsets? padding;

  const ResponsiveScroll({
    super.key,
    required this.child,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: physics ?? const BouncingScrollPhysics(),
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: child,
            ),
          ),
        );
      },
    );
  }
}
