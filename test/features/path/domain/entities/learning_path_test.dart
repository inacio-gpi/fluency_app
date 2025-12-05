import 'package:fluency_app/features/path/domain/entities/learning_path.dart';
import 'package:fluency_app/features/path/domain/entities/lesson.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LearningPath Entity', () {
    const tLesson1 = Lesson(
      id: 'lesson_1',
      title: 'Lesson 1',
      position: 1,
      status: LessonStatus.completed,
      xp: 20,
      estimatedMinutes: 5,
      tasks: [],
    );

    const tLesson2 = Lesson(
      id: 'lesson_2',
      title: 'Lesson 2',
      position: 2,
      status: LessonStatus.current,
      xp: 25,
      estimatedMinutes: 6,
      tasks: [],
    );

    const tLesson3 = Lesson(
      id: 'lesson_3',
      title: 'Lesson 3',
      position: 3,
      status: LessonStatus.locked,
      xp: 30,
      estimatedMinutes: 7,
      tasks: [],
    );

    const tPath = LearningPath(
      id: 'path_1',
      name: 'Test Path',
      description: 'Test Description',
      lessons: [tLesson1, tLesson2, tLesson3],
    );

    test('should be a valid entity', () {
      expect(tPath.id, 'path_1');
      expect(tPath.name, 'Test Path');
      expect(tPath.description, 'Test Description');
      expect(tPath.lessons.length, 3);
    });

    test('completedLessonsCount should return correct count', () {
      expect(tPath.completedLessonsCount, 1);
    });

    test('totalLessons should return total number of lessons', () {
      expect(tPath.totalLessons, 3);
    });

    test('progress should calculate correctly', () {
      expect(tPath.progress, closeTo(0.33, 0.01));
    });

    test('progress should return 0 when no lessons', () {
      const emptyPath = LearningPath(
        id: 'path_1',
        name: 'Empty',
        description: 'Empty',
        lessons: [],
      );

      expect(emptyPath.progress, 0.0);
    });

    test('copyWith should return new instance with updated values', () {
      final updated = tPath.copyWith(name: 'New Name');

      expect(updated.id, tPath.id);
      expect(updated.name, 'New Name');
      expect(updated.description, tPath.description);
    });
  });
}

