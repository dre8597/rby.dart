import 'package:flutter/widgets.dart';
import 'package:rby/rby.dart';

/// Animates the scale for the [child] immediately or after the given [delay].
class ImmediateScaleAnimation extends ImmediateImplicitAnimation<double> {
  const ImmediateScaleAnimation({
    super.key,
    required super.child,
    required super.duration,
    super.begin = 0,
    super.end = 1,
    super.curve,
    super.delay,
  });

  @override
  ImmediateImplictAnimationState<ImmediateImplicitAnimation<double>, double>
  createState() => _ImmediateScaleAnimationState();
}

class _ImmediateScaleAnimationState
    extends ImmediateImplictAnimationState<ImmediateScaleAnimation, double> {
  @override
  ImplicitlyAnimatedWidget buildAnimated(Widget child, double value) {
    return AnimatedScale(
      scale: value,
      duration: widget.duration,
      curve: widget.curve,
      child: widget.child,
    );
  }
}
