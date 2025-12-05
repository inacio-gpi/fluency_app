import 'package:equatable/equatable.dart';

abstract class PathEvent extends Equatable {
  const PathEvent();

  @override
  List<Object?> get props => [];
}

class LoadPathEvent extends PathEvent {}

class RefreshPathEvent extends PathEvent {}

class ResetProgressEvent extends PathEvent {}

