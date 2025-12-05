import 'package:fluency_app/core/routes/app_routes.dart';
import 'package:fluency_app/features/lesson/di/lesson_binding.dart';
import 'package:fluency_app/features/lesson/presentation/pages/lesson_tasks_page.dart';
import 'package:fluency_app/features/path/di/path_binding.dart';
import 'package:fluency_app/features/path/presentation/pages/path_page.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.path,
      page: () => PathPage(controller: Get.find()),
      binding: PathBinding(),
    ),
    GetPage(
      name: AppRoutes.lessonTasks,
      page: () {
        final lessonId = Get.parameters['lessonId'] ?? '';
        return LessonTasksPage(lessonId: lessonId, controller: Get.find());
      },
      binding: LessonBinding(),
    ),
  ];
}
