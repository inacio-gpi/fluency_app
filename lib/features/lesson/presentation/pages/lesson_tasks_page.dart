import 'package:fluency_app/core/theme/app_theme.dart';
import 'package:fluency_app/features/lesson/presentation/controller/lesson_controller.dart';
import 'package:fluency_app/features/lesson/presentation/controller/lesson_event.dart';
import 'package:fluency_app/features/lesson/presentation/controller/lesson_state.dart';
import 'package:fluency_app/features/lesson/presentation/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LessonTasksPage extends StatefulWidget {
  final String lessonId;
  final LessonController controller;

  const LessonTasksPage({
    super.key,
    required this.lessonId,
    required this.controller,
  });

  @override
  State<LessonTasksPage> createState() => _LessonTasksPageState();
}

class _LessonTasksPageState extends State<LessonTasksPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onStateChanged);
    widget.controller.handleEvent(LoadLessonEvent(lessonId: widget.lessonId));
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.controller.state;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (state is LessonLoaded) {
          widget.controller.handleEvent(SaveProgressEvent());
        }
        await Future.delayed(const Duration(milliseconds: 300));
        Get.back();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tarefas da Lição'),
          centerTitle: true,
        ),
        body: _buildBody(state),
      ),
    );
  }

  Widget _buildBody(LessonState state) {
    if (state is LessonLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is LessonError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Algo deu errado',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                state.message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                widget.controller.handleEvent(
                  LoadLessonEvent(lessonId: widget.lessonId),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (state is LessonLoaded || state is LessonProgressUpdating) {
      final lesson = state is LessonLoaded
          ? state.lesson
          : (state as LessonProgressUpdating).lesson;
      final completedTaskIds = state is LessonLoaded
          ? state.completedTaskIds
          : (state as LessonProgressUpdating).completedTaskIds;
      final isUpdating = state is LessonProgressUpdating;

      final completedCount = completedTaskIds.length;
      final totalCount = lesson.tasks.length;
      final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

      return Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: Theme.of(
                    context,
                  ).textTheme.displaySmall?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.white, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${lesson.xp} XP',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '~${lesson.estimatedMinutes} min',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Progresso',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$completedCount de $totalCount tarefas',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 6,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.3,
                              ),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              '${(progress * 100).toInt()}%',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: lesson.tasks.length,
              itemBuilder: (context, index) {
                final task = lesson.tasks[index];
                final isCompleted = completedTaskIds.contains(task.id);

                return TaskCard(
                  task: task,
                  isCompleted: isCompleted,
                  onToggle: isUpdating
                      ? () {}
                      : () {
                          widget.controller.handleEvent(
                            ToggleTaskCompletionEvent(taskId: task.id),
                          );
                        },
                );
              },
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
