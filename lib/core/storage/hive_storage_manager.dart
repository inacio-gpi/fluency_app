import 'package:fluency_app/core/errors/exceptions.dart';
import 'package:hive/hive.dart';

class HiveStorageManager {
  static HiveStorageManager? _instance;
  final Map<String, Box<dynamic>> _boxes = {};

  HiveStorageManager._();

  static HiveStorageManager get instance {
    _instance ??= HiveStorageManager._();
    return _instance!;
  }

  Future<Box<dynamic>> getBox(String boxName) async {
    if (_boxes.containsKey(boxName) && _boxes[boxName]!.isOpen) {
      return _boxes[boxName]!;
    }

    try {
      final box = await Hive.openBox(boxName);
      _boxes[boxName] = box;
      return box;
    } catch (e) {
      throw CacheException(
        message: 'Failed to open box $boxName: $e',
        code: '500',
      );
    }
  }

  Future<T?> get<T>(String boxName, String key) async {
    try {
      final box = await getBox(boxName);
      return box.get(key) as T?;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get data from box $boxName: $e',
        code: '500',
      );
    }
  }

  Future<void> put(String boxName, String key, dynamic value) async {
    try {
      final box = await getBox(boxName);
      await box.put(key, value);
    } catch (e) {
      throw CacheException(
        message: 'Failed to put data in box $boxName: $e',
        code: '500',
      );
    }
  }

  Future<void> delete(String boxName, String key) async {
    try {
      final box = await getBox(boxName);
      await box.delete(key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to delete data from box $boxName: $e',
        code: '500',
      );
    }
  }

  Future<void> clear(String boxName) async {
    try {
      final box = await getBox(boxName);
      await box.clear();
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear box $boxName: $e',
        code: '500',
      );
    }
  }

  Future<void> closeBox(String boxName) async {
    if (_boxes.containsKey(boxName)) {
      await _boxes[boxName]!.close();
      _boxes.remove(boxName);
    }
  }

  Future<void> closeAllBoxes() async {
    for (final box in _boxes.values) {
      await box.close();
    }
    _boxes.clear();
  }
}

