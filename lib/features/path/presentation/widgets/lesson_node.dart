import 'package:fluency_app/core/theme/app_theme.dart';
import 'package:fluency_app/features/path/domain/entities/lesson.dart';
import 'package:flutter/material.dart';

class LessonNode extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;
  final bool showConnector;

  const LessonNode({
    super.key,
    required this.lesson,
    required this.onTap,
    this.showConnector = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showConnector) _buildConnector(),
        GestureDetector(
          onTap: lesson.status != LessonStatus.locked ? onTap : null,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 500),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.5 + (0.5 * value),
                child: Opacity(opacity: value, child: child),
              );
            },
            child: _buildNode(context),
          ),
        ),
      ],
    );
  }

  Widget _buildConnector() {
    Color connectorColor;
    switch (lesson.status) {
      case LessonStatus.completed:
        connectorColor = AppTheme.successColor;
        break;
      case LessonStatus.current:
        connectorColor = AppTheme.primaryColor;
        break;
      case LessonStatus.locked:
        connectorColor = AppTheme.lockedColor;
        break;
    }

    return Container(
      width: 4,
      height: 40,
      decoration: BoxDecoration(
        color: connectorColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildNode(BuildContext context) {
    Color nodeColor;
    Color borderColor;
    IconData? icon;

    switch (lesson.status) {
      case LessonStatus.completed:
        nodeColor = AppTheme.successColor;
        borderColor = AppTheme.successColor;
        icon = Icons.check;
        break;
      case LessonStatus.current:
        nodeColor = AppTheme.primaryColor;
        borderColor = AppTheme.primaryColor;
        icon = Icons.play_arrow;
        break;
      case LessonStatus.locked:
        nodeColor = AppTheme.lockedColor.withValues(alpha: 0.3);
        borderColor = AppTheme.lockedColor;
        icon = Icons.lock;
        break;
    }

    return Container(
      width: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 3),
        boxShadow: lesson.status == LessonStatus.current
            ? [
                BoxShadow(
                  color: nodeColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: nodeColor, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            lesson.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: lesson.status == LessonStatus.locked
                  ? AppTheme.textSecondaryColor
                  : AppTheme.textPrimaryColor,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                size: 16,
                color: lesson.status == LessonStatus.locked
                    ? AppTheme.textSecondaryColor
                    : AppTheme.warningColor,
              ),
              const SizedBox(width: 4),
              Text(
                '${lesson.xp} XP',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: lesson.status == LessonStatus.locked
                      ? AppTheme.textSecondaryColor
                      : AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (lesson.completedTasksCount > 0) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: lesson.progress,
              backgroundColor: AppTheme.lockedColor.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(nodeColor),
            ),
          ],
        ],
      ),
    );
  }
}
