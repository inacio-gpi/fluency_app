import 'package:equatable/equatable.dart';
import 'package:fluency_app/features/path/domain/entities/lesson.dart';

abstract class LessonState extends Equatable {
  const LessonState();

  @override
  List<Object?> get props => [];
}

class LessonInitial extends LessonState {}

class LessonLoading extends LessonState {}

class LessonLoaded extends LessonState {
  final Lesson lesson;
  final Set<String> completedTaskIds;

  const LessonLoaded({
    required this.lesson,
    required this.completedTaskIds,
  });

  @override
  List<Object?> get props => [lesson, completedTaskIds];

  LessonLoaded copyWith({
    Lesson? lesson,
    Set<String>? completedTaskIds,
  }) {
    return LessonLoaded(
      lesson: lesson ?? this.lesson,
      completedTaskIds: completedTaskIds ?? this.completedTaskIds,
    );
  }
}

class LessonError extends LessonState {
  final String message;

  const LessonError({required this.message});

  @override
  List<Object?> get props => [message];
}

class LessonProgressUpdating extends LessonState {
  final Lesson lesson;
  final Set<String> completedTaskIds;

  const LessonProgressUpdating({
    required this.lesson,
    required this.completedTaskIds,
  });

  @override
  List<Object?> get props => [lesson, completedTaskIds];
}

