import 'package:fluency_app/features/path/data/models/lesson_model.dart';
import 'package:fluency_app/features/path/domain/entities/learning_path.dart';

class LearningPathModel extends LearningPath {
  const LearningPathModel({
    required super.id,
    required super.name,
    required super.description,
    required super.lessons,
  });

  factory LearningPathModel.fromMap(Map<String, dynamic> map) {
    return LearningPathModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      lessons:
          (map['lessons'] as List<dynamic>?)
              ?.map(
                (lesson) =>
                    LessonModel.fromMap(Map<String, dynamic>.from(lesson)),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'lessons': lessons
          .map((lesson) => LessonModel.fromEntity(lesson).toJson())
          .toList(),
    };
  }

  factory LearningPathModel.fromEntity(LearningPath path) {
    return LearningPathModel(
      id: path.id,
      name: path.name,
      description: path.description,
      lessons: path.lessons,
    );
  }
}
