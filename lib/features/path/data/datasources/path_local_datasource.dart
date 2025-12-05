import 'package:fluency_app/core/errors/exceptions.dart';
import 'package:fluency_app/core/storage/hive_storage_manager.dart';
import 'package:fluency_app/features/path/data/models/learning_path_model.dart';

abstract class PathLocalDataSource {
  Future<LearningPathModel?> getCachedPath();
  Future<void> cachePath(LearningPathModel path);
  Future<void> cacheTaskProgress(
    String lessonId,
    List<String> completedTaskIds,
  );
  Future<List<String>?> getCompletedTaskIds(String lessonId);
  Future<void> clearAllProgress();
  Future<void> cacheLessonStatus(String lessonId, String status);
  Future<String?> getLessonStatus(String lessonId);
}

class PathLocalDataSourceImpl implements PathLocalDataSource {
  static const String _boxName = 'learning_path';
  static const String _pathKey = 'current_path';
  static const String _taskProgressPrefix = 'task_progress_';
  static const String _lessonStatusPrefix = 'lesson_status_';

  final HiveStorageManager storageManager;

  PathLocalDataSourceImpl({required this.storageManager});

  @override
  Future<LearningPathModel?> getCachedPath() async {
    try {
      final data = await storageManager.get<Map<dynamic, dynamic>>(
        _boxName,
        _pathKey,
      );
      if (data == null) return null;

      return LearningPathModel.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      throw CacheException(
        message: 'Failed to get cached path: $e',
        code: '500',
      );
    }
  }

  @override
  Future<void> cachePath(LearningPathModel path) async {
    try {
      await storageManager.put(_boxName, _pathKey, path.toMap());
    } catch (e) {
      throw CacheException(message: 'Failed to cache path: $e', code: '500');
    }
  }

  @override
  Future<void> cacheTaskProgress(
    String lessonId,
    List<String> completedTaskIds,
  ) async {
    try {
      final key = '$_taskProgressPrefix$lessonId';
      await storageManager.put(_boxName, key, completedTaskIds);
    } catch (e) {
      throw CacheException(
        message: 'Failed to cache task progress: $e',
        code: '500',
      );
    }
  }

  @override
  Future<List<String>?> getCompletedTaskIds(String lessonId) async {
    try {
      final key = '$_taskProgressPrefix$lessonId';
      final data = await storageManager.get<List<dynamic>>(_boxName, key);
      return data?.cast<String>();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get completed task IDs: $e',
        code: '500',
      );
    }
  }

  @override
  Future<void> clearAllProgress() async {
    try {
      await storageManager.clear(_boxName);
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear progress: $e',
        code: '500',
      );
    }
  }

  @override
  Future<void> cacheLessonStatus(String lessonId, String status) async {
    try {
      final key = '$_lessonStatusPrefix$lessonId';
      await storageManager.put(_boxName, key, status);
    } catch (e) {
      throw CacheException(
        message: 'Failed to cache lesson status: $e',
        code: '500',
      );
    }
  }

  @override
  Future<String?> getLessonStatus(String lessonId) async {
    try {
      final key = '$_lessonStatusPrefix$lessonId';
      return await storageManager.get<String>(_boxName, key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get lesson status: $e',
        code: '500',
      );
    }
  }
}
