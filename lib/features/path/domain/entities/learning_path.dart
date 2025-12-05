import 'package:equatable/equatable.dart';
import 'package:fluency_app/features/path/domain/entities/lesson.dart';

class LearningPath extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<Lesson> lessons;

  const LearningPath({
    required this.id,
    required this.name,
    required this.description,
    required this.lessons,
  });

  int get completedLessonsCount =>
      lessons.where((lesson) => lesson.status == LessonStatus.completed).length;

  int get totalLessons => lessons.length;

  double get progress =>
      totalLessons > 0 ? completedLessonsCount / totalLessons : 0.0;

  LearningPath copyWith({
    String? id,
    String? name,
    String? description,
    List<Lesson>? lessons,
  }) {
    return LearningPath(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      lessons: lessons ?? this.lessons,
    );
  }

  @override
  List<Object?> get props => [id, name, description, lessons];
}
