import 'package:flutter_test/flutter_test.dart';
import 'package:fluency_app/core/storage/hive_storage_manager.dart';

void main() {
  group('HiveStorageManager', () {
    test('should return singleton instance', () {
      final instance1 = HiveStorageManager.instance;
      final instance2 = HiveStorageManager.instance;

      expect(instance1, same(instance2));
    });

    test('should be instantiated', () {
      final instance = HiveStorageManager.instance;
      expect(instance, isA<HiveStorageManager>());
    });
  });
}

