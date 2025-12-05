import 'package:flutter_test/flutter_test.dart';
import 'package:fluency_app/features/path/data/models/learning_path_model.dart';
import 'package:fluency_app/features/path/data/models/lesson_model.dart';
import 'package:fluency_app/features/path/domain/entities/learning_path.dart';
import 'package:fluency_app/features/path/domain/entities/lesson.dart';

void main() {
  const tLessonModel = LessonModel(
    id: 'lesson_1',
    title: 'Test Lesson',
    position: 1,
    status: LessonStatus.current,
    xp: 20,
    estimatedMinutes: 5,
    tasks: [],
  );

  const tPathModel = LearningPathModel(
    id: 'path_1',
    name: 'Test Path',
    description: 'Test Description',
    lessons: [tLessonModel],
  );

  group('LearningPathModel', () {
    test('should be a subclass of LearningPath entity', () {
      expect(tPathModel, isA<LearningPath>());
    });

    group('fromMap', () {
      test('should return a valid model from JSON', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          'id': 'path_1',
          'name': 'Test Path',
          'description': 'Test Description',
          'lessons': [
            {
              'id': 'lesson_1',
              'title': 'Test Lesson',
              'position': 1,
              'status': 'current',
              'xp': 20,
              'estimatedMinutes': 5,
              'tasks': [],
            }
          ],
        };

        // act
        final result = LearningPathModel.fromMap(jsonMap);

        // assert
        expect(result, tPathModel);
      });

      test('should handle empty lessons list', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          'id': 'path_1',
          'name': 'Test Path',
          'description': 'Test Description',
          'lessons': [],
        };

        // act
        final result = LearningPathModel.fromMap(jsonMap);

        // assert
        expect(result.lessons, isEmpty);
      });
    });

    group('toMap', () {
      test('should return a JSON map containing proper data', () {
        // act
        final result = tPathModel.toMap();

        // assert
        expect(result['id'], 'path_1');
        expect(result['name'], 'Test Path');
        expect(result['description'], 'Test Description');
        expect(result['lessons'], isA<List>());
      });
    });

    group('fromEntity', () {
      test('should create model from entity', () {
        // arrange
        const entity = LearningPath(
          id: 'path_1',
          name: 'Test Path',
          description: 'Test Desc',
          lessons: [],
        );

        // act
        final result = LearningPathModel.fromEntity(entity);

        // assert
        expect(result.id, entity.id);
        expect(result.name, entity.name);
        expect(result.description, entity.description);
      });
    });
  });
}

