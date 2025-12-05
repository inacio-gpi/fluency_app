import 'package:fluency_app/core/theme/app_theme.dart';
import 'package:fluency_app/features/path/domain/entities/task.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final bool isCompleted;
  final VoidCallback onToggle;

  const TaskCard({
    super.key,
    required this.task,
    required this.isCompleted,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppTheme.successColor
                        : AppTheme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      isCompleted
                          ? Icons.check_circle
                          : _getTaskIcon(task.type),
                      key: ValueKey(isCompleted),
                      color: isCompleted ? Colors.white : AppTheme.primaryColor,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: isCompleted
                              ? AppTheme.textSecondaryColor
                              : AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _formatTaskType(task.type),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppTheme.secondaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: AppTheme.textSecondaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDuration(task.estimatedSeconds),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted
                          ? AppTheme.successColor
                          : AppTheme.lockedColor,
                      width: 2,
                    ),
                    color: isCompleted
                        ? AppTheme.successColor
                        : Colors.transparent,
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getTaskIcon(String type) {
    switch (type.toLowerCase()) {
      case 'listen_repeat':
        return Icons.headphones;
      case 'multiple_choice':
        return Icons.quiz;
      case 'fill_in_the_blanks':
        return Icons.edit;
      case 'ordering':
        return Icons.reorder;
      case 'role_play':
        return Icons.record_voice_over;
      default:
        return Icons.assignment;
    }
  }

  String _formatTaskType(String type) {
    switch (type.toLowerCase()) {
      case 'listen_repeat':
        return 'Ouça e Repita';
      case 'multiple_choice':
        return 'Múltipla Escolha';
      case 'fill_in_the_blanks':
        return 'Preencher Lacunas';
      case 'ordering':
        return 'Ordenação';
      case 'role_play':
        return 'Role-play';
      default:
        return type;
    }
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '${seconds}s';
    }
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (remainingSeconds == 0) {
      return '${minutes}min';
    }
    return '${minutes}min ${remainingSeconds}s';
  }
}
