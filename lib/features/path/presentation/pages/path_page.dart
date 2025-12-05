import 'package:fluency_app/core/presentation/widgets/animated_progress_indicator.dart';
import 'package:fluency_app/core/routes/app_routes.dart';
import 'package:fluency_app/core/theme/app_theme.dart';
import 'package:fluency_app/features/path/presentation/controller/path_controller.dart';
import 'package:fluency_app/features/path/presentation/controller/path_event.dart';
import 'package:fluency_app/features/path/presentation/controller/path_state.dart';
import 'package:fluency_app/features/path/presentation/widgets/lesson_node.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PathPage extends StatefulWidget {
  final PathController controller;

  const PathPage({super.key, required this.controller});

  @override
  State<PathPage> createState() => _PathPageState();
}

class _PathPageState extends State<PathPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onStateChanged);
    widget.controller.handleEvent(LoadPathEvent());
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

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resetar Progresso'),
        content: const Text(
          'Tem certeza que deseja resetar todo o progresso? '
          'Todas as tarefas concluídas e lições desbloqueadas serão perdidas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.controller.handleEvent(ResetProgressEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Resetar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.controller.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fluency'),
        centerTitle: true,
        actions: [
          if (state is PathLoaded) ...[
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Atualizar',
              onPressed: () {
                widget.controller.handleEvent(RefreshPathEvent());
              },
            ),
            IconButton(
              icon: const Icon(Icons.restart_alt),
              tooltip: 'Resetar Progresso',
              onPressed: () {
                _showResetDialog(context);
              },
            ),
          ],
        ],
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(PathState state) {
    if (state is PathLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is PathError) {
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
              'Oops! Algo deu erradoaa',
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
                widget.controller.handleEvent(LoadPathEvent());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (state is PathLoaded) {
      final path = state.path;

      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    path.name,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    path.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Progresso',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${path.completedLessonsCount}/${path.totalLessons} lições',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                        AnimatedProgressIndicator(
                          progress: path.progress,
                          progressColor: AppTheme.primaryColor,
                          backgroundColor: Colors.white.withValues(alpha: 0.3),
                          textColor: AppTheme.textPrimaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final lesson = path.lessons[index];
                return Center(
                  child: LessonNode(
                    lesson: lesson,
                    showConnector: index > 0,
                    onTap: () {
                      Get.toNamed(AppRoutes.lessonTasksWithId(lesson.id))?.then(
                        (_) {
                          widget.controller.handleEvent(RefreshPathEvent());
                        },
                      );
                    },
                  ),
                );
              }, childCount: path.lessons.length),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
