import 'package:flutter/material.dart';

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    super.key,
    required this.child,
    required this.shake,
    this.offset = 0.015,
    this.duration = const Duration(milliseconds: 500),
  });

  final Widget child;
  final bool shake;
  final double offset;
  final Duration duration;

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    // Sostituisci la riga dell'animazione con questa:
    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: widget.offset),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.offset, end: -widget.offset),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -widget.offset, end: 0.0),
        weight: 1,
      ),
    ]).animate(_controller); // <-- Passa direttamente _controller qui

    if (widget.shake) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant ShakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.shake != oldWidget.shake) {
      if (widget.shake) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) {
        return Transform.rotate(angle: _animation.value, child: child);
      },
    );
  }
}
