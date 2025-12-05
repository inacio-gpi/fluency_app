import 'package:fluency_app/features/path/data/models/task_model.dart';
import 'package:fluency_app/features/path/domain/entities/lesson.dart';

class LessonModel extends Lesson {
  const LessonModel({
    required super.id,
    required super.title,
    required super.position,
    required super.status,
    required super.xp,
    required super.estimatedMinutes,
    required super.tasks,
  });

  factory LessonModel.fromMap(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      title: json['title'] as String,
      position: json['position'] as int,
      status: _statusFromString(json['status'] as String),
      xp: json['xp'] as int,
      estimatedMinutes: json['estimatedMinutes'] as int,
      tasks:
          (json['tasks'] as List<dynamic>?)
              ?.map(
                (task) => TaskModel.fromMap(Map<String, dynamic>.from(task)),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'position': position,
      'status': _statusToString(status),
      'xp': xp,
      'estimatedMinutes': estimatedMinutes,
      'tasks': tasks.map((task) => TaskModel.fromEntity(task).toMap()).toList(),
    };
  }

  factory LessonModel.fromEntity(Lesson lesson) {
    return LessonModel(
      id: lesson.id,
      title: lesson.title,
      position: lesson.position,
      status: lesson.status,
      xp: lesson.xp,
      estimatedMinutes: lesson.estimatedMinutes,
      tasks: lesson.tasks,
    );
  }

  static LessonStatus _statusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return LessonStatus.completed;
      case 'current':
        return LessonStatus.current;
      case 'locked':
        return LessonStatus.locked;
      default:
        return LessonStatus.locked;
    }
  }

  static String _statusToString(LessonStatus status) {
    switch (status) {
      case LessonStatus.completed:
        return 'completed';
      case LessonStatus.current:
        return 'current';
      case LessonStatus.locked:
        return 'locked';
    }
  }
}
