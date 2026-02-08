import 'package:flutter/material.dart';
import '../theme/motion.dart';

class StaggeredIn extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration duration;
  final Duration baseDelay;
  final Curve curve;
  final Offset offset;

  const StaggeredIn({
    super.key,
    required this.child,
    required this.index,
    this.duration = MotionTokens.short,
    this.baseDelay = const Duration(milliseconds: 40),
    this.curve = MotionTokens.movementCurve,
    this.offset = const Offset(0, 0.04),
  });

  @override
  State<StaggeredIn> createState() => _StaggeredInState();
}

class _StaggeredInState extends State<StaggeredIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _controller, curve: widget.curve);
    _slide = Tween<Offset>(begin: widget.offset, end: Offset.zero).animate(_fade);
    _play();
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
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}
