import 'package:flutter/material.dart';

class AnimatedLinearProgressIndicator extends StatelessWidget {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double height;
  final Duration animationDuration;
  final BorderRadius? borderRadius;

  const AnimatedLinearProgressIndicator({
    super.key,
    required this.progress,
    required this.progressColor,
    this.backgroundColor = Colors.transparent,
    this.height = 4.0,
    this.animationDuration = const Duration(milliseconds: 800),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: animationDuration,
      curve: Curves.easeInOut,
      tween: Tween<double>(
        begin: 0,
        end: progress,
      ),
      builder: (context, animatedValue, child) {
        return ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
          child: SizedBox(
            height: height,
            child: LinearProgressIndicator(
              value: animatedValue,
              backgroundColor: backgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
        );
      },
    );
  }
}

