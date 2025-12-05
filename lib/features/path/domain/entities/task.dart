import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String type;
  final int estimatedSeconds;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    required this.type,
    required this.estimatedSeconds,
    this.isCompleted = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? type,
    int? estimatedSeconds,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      estimatedSeconds: estimatedSeconds ?? this.estimatedSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, title, type, estimatedSeconds, isCompleted];
}

