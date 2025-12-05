import 'package:flutter/material.dart';

class AnimatedProgressIndicator extends StatelessWidget {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final Color textColor;
  final double size;
  final double indicatorSize;
  final double strokeWidth;
  final Duration animationDuration;

  const AnimatedProgressIndicator({
    super.key,
    required this.progress,
    required this.progressColor,
    this.backgroundColor = Colors.transparent,
    this.textColor = Colors.black,
    this.size = 60,
    this.indicatorSize = 40,
    this.strokeWidth = 6,
    this.animationDuration = const Duration(milliseconds: 800),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        duration: animationDuration,
        curve: Curves.easeInOut,
        tween: Tween<double>(
          begin: 0,
          end: progress,
        ),
        builder: (context, animatedValue, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: indicatorSize,
                height: indicatorSize,
                child: CircularProgressIndicator(
                  value: animatedValue,
                  strokeWidth: strokeWidth,
                  backgroundColor: backgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
              TweenAnimationBuilder<int>(
                duration: animationDuration,
                curve: Curves.easeInOut,
                tween: IntTween(
                  begin: 0,
                  end: (progress * 100).toInt(),
                ),
                builder: (context, animatedPercentage, child) {
                  return Text(
                    '$animatedPercentage%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

