import 'package:equatable/equatable.dart';

abstract class LessonEvent extends Equatable {
  const LessonEvent();

  @override
  List<Object?> get props => [];
}

class LoadLessonEvent extends LessonEvent {
  final String lessonId;

  const LoadLessonEvent({required this.lessonId});

  @override
  List<Object?> get props => [lessonId];
}

class ToggleTaskCompletionEvent extends LessonEvent {
  final String taskId;

  const ToggleTaskCompletionEvent({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class SaveProgressEvent extends LessonEvent {}

