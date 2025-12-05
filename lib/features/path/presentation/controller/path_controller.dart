import 'package:fluency_app/core/presentation/base_controller.dart';
import 'package:fluency_app/features/path/domain/usecases/get_learning_path.dart';
import 'package:fluency_app/features/path/domain/usecases/reset_progress.dart';
import 'package:fluency_app/features/path/presentation/controller/path_event.dart';
import 'package:fluency_app/features/path/presentation/controller/path_state.dart';

class PathController extends BaseController<PathState> {
  final GetLearningPath getLearningPath;
  final ResetProgress resetProgress;

  PathController({required this.getLearningPath, required this.resetProgress})
    : super(PathInitial());

  void handleEvent(PathEvent event) {
    if (event is LoadPathEvent) {
      _onLoadPath();
    } else if (event is RefreshPathEvent) {
      _onRefreshPath();
    } else if (event is ResetProgressEvent) {
      _onResetProgress();
    }
  }

  Future<void> _onLoadPath() async {
    emit(PathLoading());

    final result = await getLearningPath();

    result.fold(
      (failure) => emit(PathError(message: failure.message)),
      (path) => emit(PathLoaded(path: path)),
    );
  }

  Future<void> _onRefreshPath() async {
    final result = await getLearningPath();

    result.fold(
      (failure) => emit(PathError(message: failure.message)),
      (path) => emit(PathLoaded(path: path)),
    );
  }

  Future<void> _onResetProgress() async {
    emit(PathLoading());

    final resetResult = await resetProgress();

    await resetResult.fold(
      (failure) async {
        emit(PathError(message: failure.message));
      },
      (_) async {
        final result = await getLearningPath();
        result.fold(
          (failure) => emit(PathError(message: failure.message)),
          (path) => emit(PathLoaded(path: path)),
        );
      },
    );
  }
}
