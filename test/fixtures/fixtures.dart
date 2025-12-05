import 'package:fluency_app/features/path/domain/entities/learning_path.dart';
import 'package:fluency_app/features/path/domain/entities/lesson.dart';
import 'package:fluency_app/features/path/domain/entities/task.dart';

class Fixtures {
  static Task get task1 => const Task(
    id: 'task_1',
    title: 'Test Task 1',
    type: 'listen_repeat',
    estimatedSeconds: 60,
    isCompleted: false,
  );

  static Task get task2 => const Task(
    id: 'task_2',
    title: 'Test Task 2',
    type: 'multiple_choice',
    estimatedSeconds: 90,
    isCompleted: false,
  );

  static Task get task3 => const Task(
    id: 'task_3',
    title: 'Test Task 3',
    type: 'fill_in_the_blanks',
    estimatedSeconds: 120,
    isCompleted: true,
  );

  static Lesson get completedLesson => Lesson(
    id: 'lesson_1',
    title: 'Test Lesson 1',
    position: 1,
    status: LessonStatus.completed,
    xp: 20,
    estimatedMinutes: 5,
    tasks: [task1, task2],
  );

  static Lesson get currentLesson => Lesson(
    id: 'lesson_2',
    title: 'Test Lesson 2',
    position: 2,
    status: LessonStatus.current,
    xp: 25,
    estimatedMinutes: 6,
    tasks: [task1, task2, task3],
  );

  static Lesson get lockedLesson => Lesson(
    id: 'lesson_3',
    title: 'Test Lesson 3',
    position: 3,
    status: LessonStatus.locked,
    xp: 30,
    estimatedMinutes: 7,
    tasks: [task1],
  );

  static LearningPath get learningPath => LearningPath(
    id: 'path_1',
    name: 'Test Path',
    description: 'Test Description',
    lessons: [completedLesson, currentLesson, lockedLesson],
  );
}
