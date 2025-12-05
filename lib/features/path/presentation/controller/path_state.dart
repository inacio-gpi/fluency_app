import 'package:equatable/equatable.dart';
import 'package:fluency_app/features/path/domain/entities/learning_path.dart';

abstract class PathState extends Equatable {
  const PathState();

  @override
  List<Object?> get props => [];
}

class PathInitial extends PathState {}

class PathLoading extends PathState {}

class PathLoaded extends PathState {
  final LearningPath path;

  const PathLoaded({required this.path});

  @override
  List<Object?> get props => [path];
}

class PathError extends PathState {
  final String message;

  const PathError({required this.message});

  @override
  List<Object?> get props => [message];
}

