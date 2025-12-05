import 'package:fluency_app/core/routes/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppRoutes', () {
    test('should have path route defined', () {
      expect(AppRoutes.path, '/');
    });

    test('should have lessonTasks route defined', () {
      expect(AppRoutes.lessonTasks, '/lesson-tasks/:lessonId');
    });

    test('lessonTasksWithId should generate correct route', () {
      final route = AppRoutes.lessonTasksWithId('lesson_123');
      expect(route, '/lesson-tasks/lesson_123');
    });

    test('routes should be unique', () {
      final routes = [AppRoutes.path, AppRoutes.lessonTasks];

      expect(routes.toSet().length, routes.length);
    });
  });
}
