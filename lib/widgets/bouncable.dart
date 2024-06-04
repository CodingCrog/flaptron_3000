// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class Bounceable extends StatefulWidget {
  /// Set it to `null` to disable `onTap`.
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final void Function(TapUpDetails)? onTapUp;
  final void Function(TapDownDetails)? onTapDown;
  final VoidCallback? onTapCancel;

  final Duration duration;

  final Duration reverseDuration;

  final Curve curve;

  final Curve? reverseCurve;

  final double scaleFactor;

  final HitTestBehavior? hitTestBehavior;

  final Widget child;

  const Bounceable(
      {super.key,
      this.onTap,
      required this.child,
      this.onTapUp,
      this.onTapDown,
      this.onTapCancel,
      this.duration = const Duration(milliseconds: 100),
      this.reverseDuration = const Duration(milliseconds: 100),
      this.curve = Curves.decelerate,
      this.reverseCurve = Curves.decelerate,
      this.scaleFactor = 0.95,
      this.hitTestBehavior,
      this.onLongPress})
      : assert(
          scaleFactor >= 0.0 && scaleFactor <= 1.0,
          'The valid range of scaleFactor is from 0.0 to 1.0.',
        );

  @override
  _BounceableState createState() => _BounceableState();
}

class _BounceableState extends State<Bounceable>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late double _scale;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
      lowerBound: 0.0,
      upperBound: 1 - widget.scaleFactor,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  _onTapDown(TapDownDetails details) {
    if (mounted) {
      _animationController.forward();
    }
  }

  _onTapUp(TapUpDetails details) {
    Future.delayed(widget.reverseDuration, () {
      if (mounted) {
        _animationController.reverse();
      }
    });

    widget.onTap?.call();
  }

  _onTapCancel() {
    if (mounted) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _animationController.value;
    return GestureDetector(
      key: const ValueKey('bouncable'),
      behavior: widget.hitTestBehavior,
      onTapCancel: _onTapCancel,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onLongPress: widget.onLongPress,
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
