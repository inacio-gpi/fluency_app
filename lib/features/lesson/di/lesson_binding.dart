import 'package:fluency_app/core/di/injection_container.dart';
import 'package:fluency_app/features/lesson/presentation/controller/lesson_controller.dart';
import 'package:fluency_app/features/path/domain/usecases/get_lesson.dart';
import 'package:fluency_app/features/path/domain/usecases/update_lesson_progress.dart';
import 'package:get/get.dart';

class LessonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LessonController>(
      () => LessonController(
        getLesson: getIt<GetLesson>(),
        updateLessonProgress: getIt<UpdateLessonProgress>(),
      ),
    );
  }
}
