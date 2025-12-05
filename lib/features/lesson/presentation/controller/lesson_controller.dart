import 'package:fluency_app/core/presentation/base_controller.dart';
import 'package:fluency_app/features/lesson/presentation/controller/lesson_event.dart';
import 'package:fluency_app/features/lesson/presentation/controller/lesson_state.dart';
import 'package:fluency_app/features/path/domain/usecases/get_lesson.dart';
import 'package:fluency_app/features/path/domain/usecases/update_lesson_progress.dart';

class LessonController extends BaseController<LessonState> {
  final GetLesson getLesson;
  final UpdateLessonProgress updateLessonProgress;

  LessonController({
    required this.getLesson,
    required this.updateLessonProgress,
  }) : super(LessonInitial());

  void handleEvent(LessonEvent event) {
    if (event is LoadLessonEvent) {
      _onLoadLesson(event);
    } else if (event is ToggleTaskCompletionEvent) {
      _onToggleTaskCompletion(event);
    } else if (event is SaveProgressEvent) {
      _onSaveProgress();
    }
  }

  Future<void> _onLoadLesson(LoadLessonEvent event) async {
    emit(LessonLoading());

    final result = await getLesson(event.lessonId);

    result.fold(
      (failure) => emit(LessonError(message: failure.message)),
      (lesson) {
        final completedTaskIds = lesson.tasks
            .where((task) => task.isCompleted)
            .map((task) => task.id)
            .toSet();
        emit(LessonLoaded(lesson: lesson, completedTaskIds: completedTaskIds));
      },
    );
  }

  void _onToggleTaskCompletion(ToggleTaskCompletionEvent event) {
    final currentState = state;
    if (currentState is! LessonLoaded) return;

    final updatedTaskIds = Set<String>.from(currentState.completedTaskIds);
    
    if (updatedTaskIds.contains(event.taskId)) {
      updatedTaskIds.remove(event.taskId);
    } else {
      updatedTaskIds.add(event.taskId);
    }

    emit(currentState.copyWith(completedTaskIds: updatedTaskIds));
  }

  Future<void> _onSaveProgress() async {
    final currentState = state;
    if (currentState is! LessonLoaded) return;

    emit(LessonProgressUpdating(
      lesson: currentState.lesson,
      completedTaskIds: currentState.completedTaskIds,
    ));

    final result = await updateLessonProgress(
      UpdateLessonProgressParams(
        lessonId: currentState.lesson.id,
        completedTaskIds: currentState.completedTaskIds.toList(),
      ),
    );

    result.fold(
      (failure) => emit(LessonError(message: failure.message)),
      (_) {
        emit(LessonLoaded(
          lesson: currentState.lesson,
          completedTaskIds: currentState.completedTaskIds,
        ));
      },
    );
  }
}

