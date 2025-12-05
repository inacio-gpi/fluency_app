abstract class AppRoutes {
  static const path = '/';
  static const lessonTasks = '/lesson-tasks/:lessonId';

  static String lessonTasksWithId(String lessonId) {
    return '/lesson-tasks/$lessonId';
  }
}
