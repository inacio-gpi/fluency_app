import 'package:fluency_app/features/path/domain/entities/lesson.dart';
import 'package:fluency_app/features/path/domain/entities/task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Lesson Entity', () {
    const tTask1 = Task(
      id: 'task_1',
      title: 'Task 1',
      type: 'listen_repeat',
      estimatedSeconds: 60,
      isCompleted: true,
    );

    const tTask2 = Task(
      id: 'task_2',
      title: 'Task 2',
      type: 'multiple_choice',
      estimatedSeconds: 90,
      isCompleted: false,
    );

    const tLesson = Lesson(
      id: 'lesson_1',
      title: 'Test Lesson',
      position: 1,
      status: LessonStatus.current,
      xp: 20,
      estimatedMinutes: 5,
      tasks: [tTask1, tTask2],
    );

    test('should be a valid entity', () {
      expect(tLesson.id, 'lesson_1');
      expect(tLesson.title, 'Test Lesson');
      expect(tLesson.position, 1);
      expect(tLesson.status, LessonStatus.current);
      expect(tLesson.xp, 20);
      expect(tLesson.estimatedMinutes, 5);
      expect(tLesson.tasks.length, 2);
    });

    test('completedTasksCount should return correct count', () {
      expect(tLesson.completedTasksCount, 1);
    });

    test('totalTasks should return total number of tasks', () {
      expect(tLesson.totalTasks, 2);
    });

    test('progress should calculate correctly', () {
      expect(tLesson.progress, 0.5);
    });

    test('progress should return 0 when no tasks', () {
      const emptyLesson = Lesson(
        id: 'lesson_1',
        title: 'Empty',
        position: 1,
        status: LessonStatus.current,
        xp: 20,
        estimatedMinutes: 5,
        tasks: [],
      );

      expect(emptyLesson.progress, 0.0);
    });

    test('copyWith should return new instance with updated values', () {
      final updated = tLesson.copyWith(status: LessonStatus.completed);

      expect(updated.id, tLesson.id);
      expect(updated.status, LessonStatus.completed);
      expect(updated.title, tLesson.title);
    });
  });
}

