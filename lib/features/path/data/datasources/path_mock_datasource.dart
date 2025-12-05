import 'dart:convert';

import 'package:fluency_app/core/errors/exceptions.dart';
import 'package:fluency_app/features/path/data/models/learning_path_model.dart';
import 'package:flutter/services.dart';

abstract class PathMockDataSource {
  Future<LearningPathModel> getMockPath();
}

class PathMockDataSourceImpl implements PathMockDataSource {
  @override
  Future<LearningPathModel> getMockPath() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/learning_path.json',
      );
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;

      final pathData = jsonData['path'] as Map<String, dynamic>;

      return LearningPathModel.fromMap(pathData);
    } catch (e) {
      throw DataParsingException(
        message: 'Failed to load mock path data: $e',
        code: '500',
      );
    }
  }
}
