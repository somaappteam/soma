import 'package:flutter/material.dart';
import '../theme/motion.dart';

class StaggeredIn extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration duration;
  final Duration baseDelay;
  final Curve curve;
  final Offset offset;
  final bool withScale;

  const StaggeredIn({
    super.key,
    required this.child,
    required this.index,
    this.duration = MotionTokens.short,
    this.baseDelay = const Duration(milliseconds: 40),
    this.curve = MotionTokens.standardCurve,
    this.offset = const Offset(0, 0.04),
    this.withScale = true,
  });

  @override
  State<StaggeredIn> createState() => _StaggeredInState();
}

class _StaggeredInState extends State<StaggeredIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _play();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Defer theme-dependent setup to build or ensured method
  }

  void _ensureInitialized() {
    final isLight = Theme.of(context).brightness == Brightness.light;
    if (widget.duration == MotionTokens.short) {
      _controller.duration = isLight ? MotionTokens.lightStagger : MotionTokens.darkStagger;
    }
    _configureAnimations(isLight);
  }

  void _configureAnimations(bool isLight) {
    final effectiveCurve = widget.curve == MotionTokens.standardCurve
        ? (isLight ? MotionTokens.lightStaggerCurve : MotionTokens.darkStaggerCurve)
        : widget.curve;
    _fade = CurvedAnimation(parent: _controller, curve: effectiveCurve);
    _slide = Tween<Offset>(begin: widget.offset, end: Offset.zero).animate(_fade);
    _scale = Tween<double>(begin: 0.97, end: 1).animate(_fade);
  }

  Future<void> _play() async {
    final delay = Duration(milliseconds: widget.baseDelay.inMilliseconds * widget.index);
    if (delay > Duration.zero) {
      await Future.delayed(delay);
    }
    if (!mounted) return;
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _ensureInitialized();
    Widget child = FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );

    if (widget.withScale) {
      child = ScaleTransition(scale: _scale, child: child);
    }

    return child;
  }
}
