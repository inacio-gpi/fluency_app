import 'package:fluency_app/features/path/domain/entities/task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Task Entity', () {
    const tTask = Task(
      id: 'task_1',
      title: 'Test Task',
      type: 'listen_repeat',
      estimatedSeconds: 60,
      isCompleted: false,
    );

    test('should be a valid entity', () {
      expect(tTask.id, 'task_1');
      expect(tTask.title, 'Test Task');
      expect(tTask.type, 'listen_repeat');
      expect(tTask.estimatedSeconds, 60);
      expect(tTask.isCompleted, false);
    });

    test('copyWith should return new instance with updated values', () {
      final updated = tTask.copyWith(isCompleted: true);

      expect(updated.id, tTask.id);
      expect(updated.title, tTask.title);
      expect(updated.isCompleted, true);
    });

    test('should support value equality', () {
      const task1 = Task(
        id: 'task_1',
        title: 'Test',
        type: 'type1',
        estimatedSeconds: 60,
      );

      const task2 = Task(
        id: 'task_1',
        title: 'Test',
        type: 'type1',
        estimatedSeconds: 60,
      );

      expect(task1, equals(task2));
    });
  });
}

