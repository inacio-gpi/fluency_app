import 'package:fluency_app/features/path/data/models/task_model.dart';
import 'package:fluency_app/features/path/domain/entities/task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tTaskModel = TaskModel(
    id: 'task_1',
    title: 'Test Task',
    type: 'listen_repeat',
    estimatedSeconds: 60,
    isCompleted: false,
  );

  group('TaskModel', () {
    test('should be a subclass of Task entity', () {
      expect(tTaskModel, isA<Task>());
    });

    group('fromMap', () {
      test('should return a valid model from JSON', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          'id': 'task_1',
          'title': 'Test Task',
          'type': 'listen_repeat',
          'estimatedSeconds': 60,
          'isCompleted': false,
        };

        // act
        final result = TaskModel.fromMap(jsonMap);

        // assert
        expect(result, tTaskModel);
      });

      test('should return model with isCompleted false when not provided', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          'id': 'task_1',
          'title': 'Test Task',
          'type': 'listen_repeat',
          'estimatedSeconds': 60,
        };

        // act
        final result = TaskModel.fromMap(jsonMap);

        // assert
        expect(result.isCompleted, false);
      });
    });

    group('toMap', () {
      test('should return a JSON map containing proper data', () {
        // act
        final result = tTaskModel.toMap();

        // assert
        final expectedMap = {
          'id': 'task_1',
          'title': 'Test Task',
          'type': 'listen_repeat',
          'estimatedSeconds': 60,
          'isCompleted': false,
        };

        expect(result, expectedMap);
      });
    });

    group('fromEntity', () {
      test('should create model from entity', () {
        // arrange
        const entity = Task(
          id: 'task_1',
          title: 'Test Task',
          type: 'listen_repeat',
          estimatedSeconds: 60,
        );

        // act
        final result = TaskModel.fromEntity(entity);

        // assert
        expect(result.id, entity.id);
        expect(result.title, entity.title);
        expect(result.type, entity.type);
      });
    });
  });
}
