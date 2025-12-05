import 'package:fluency_app/features/path/domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    required super.type,
    required super.estimatedSeconds,
    super.isCompleted,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      type: map['type'] as String,
      estimatedSeconds: map['estimatedSeconds'] as int,
      isCompleted: map['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'estimatedSeconds': estimatedSeconds,
      'isCompleted': isCompleted,
    };
  }

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      type: task.type,
      estimatedSeconds: task.estimatedSeconds,
      isCompleted: task.isCompleted,
    );
  }
}
