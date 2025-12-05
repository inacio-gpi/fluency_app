import 'package:flutter_test/flutter_test.dart';
import 'package:fluency_app/features/path/data/models/lesson_model.dart';
import 'package:fluency_app/features/path/data/models/task_model.dart';
import 'package:fluency_app/features/path/domain/entities/lesson.dart';

void main() {
  const tTaskModel = TaskModel(
    id: 'task_1',
    title: 'Test Task',
    type: 'listen_repeat',
    estimatedSeconds: 60,
  );

  const tLessonModel = LessonModel(
    id: 'lesson_1',
    title: 'Test Lesson',
    position: 1,
    status: LessonStatus.current,
    xp: 20,
    estimatedMinutes: 5,
    tasks: [tTaskModel],
  );

  group('LessonModel', () {
    test('should be a subclass of Lesson entity', () {
      expect(tLessonModel, isA<Lesson>());
    });

    group('fromMap', () {
      test('should return a valid model from JSON', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          'id': 'lesson_1',
          'title': 'Test Lesson',
          'position': 1,
          'status': 'current',
          'xp': 20,
          'estimatedMinutes': 5,
          'tasks': [
            {
              'id': 'task_1',
              'title': 'Test Task',
              'type': 'listen_repeat',
              'estimatedSeconds': 60,
            }
          ],
        };

        // act
        final result = LessonModel.fromMap(jsonMap);

        // assert
        expect(result, tLessonModel);
      });

      test('should parse completed status correctly', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          'id': 'lesson_1',
          'title': 'Test Lesson',
          'position': 1,
          'status': 'completed',
          'xp': 20,
          'estimatedMinutes': 5,
          'tasks': [],
        };

        // act
        final result = LessonModel.fromMap(jsonMap);

        // assert
        expect(result.status, LessonStatus.completed);
      });

      test('should parse locked status correctly', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          'id': 'lesson_1',
          'title': 'Test Lesson',
          'position': 1,
          'status': 'locked',
          'xp': 20,
          'estimatedMinutes': 5,
          'tasks': [],
        };

        // act
        final result = LessonModel.fromMap(jsonMap);

        // assert
        expect(result.status, LessonStatus.locked);
      });

      test('should default to locked for unknown status', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          'id': 'lesson_1',
          'title': 'Test Lesson',
          'position': 1,
          'status': 'unknown_status',
          'xp': 20,
          'estimatedMinutes': 5,
          'tasks': [],
        };

        // act
        final result = LessonModel.fromMap(jsonMap);

        // assert
        expect(result.status, LessonStatus.locked);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // act
        final result = tLessonModel.toJson();

        // assert
        expect(result['id'], 'lesson_1');
        expect(result['title'], 'Test Lesson');
        expect(result['position'], 1);
        expect(result['status'], 'current');
        expect(result['xp'], 20);
        expect(result['estimatedMinutes'], 5);
        expect(result['tasks'], isA<List>());
      });
    });

    group('fromEntity', () {
      test('should create model from entity', () {
        // arrange
        const entity = Lesson(
          id: 'lesson_1',
          title: 'Test',
          position: 1,
          status: LessonStatus.current,
          xp: 20,
          estimatedMinutes: 5,
          tasks: [],
        );

        // act
        final result = LessonModel.fromEntity(entity);

        // assert
        expect(result.id, entity.id);
        expect(result.title, entity.title);
        expect(result.status, entity.status);
      });
    });
  });
}

