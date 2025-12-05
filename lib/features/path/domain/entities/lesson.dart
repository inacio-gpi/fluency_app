import 'package:equatable/equatable.dart';
import 'package:fluency_app/features/path/domain/entities/task.dart';

enum LessonStatus { completed, current, locked }

class Lesson extends Equatable {
  final String id;
  final String title;
  final int position;
  final LessonStatus status;
  final int xp;
  final int estimatedMinutes;
  final List<Task> tasks;

  const Lesson({
    required this.id,
    required this.title,
    required this.position,
    required this.status,
    required this.xp,
    required this.estimatedMinutes,
    required this.tasks,
  });

  int get completedTasksCount => tasks.where((task) => task.isCompleted).length;

  int get totalTasks => tasks.length;

  double get progress =>
      totalTasks > 0 ? completedTasksCount / totalTasks : 0.0;

  Lesson copyWith({
    String? id,
    String? title,
    int? position,
    LessonStatus? status,
    int? xp,
    int? estimatedMinutes,
    List<Task>? tasks,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      position: position ?? this.position,
      status: status ?? this.status,
      xp: xp ?? this.xp,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    position,
    status,
    xp,
    estimatedMinutes,
    tasks,
  ];
}
