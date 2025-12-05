import 'package:fluency_app/core/di/injection_module.dart';
import 'package:fluency_app/core/storage/hive_storage_manager.dart';
import 'package:get_it/get_it.dart';

class CoreInjection implements InjectionModule {
  @override
  Future<void> register(GetIt getIt) async {
    getIt.registerLazySingleton<HiveStorageManager>(
      () => HiveStorageManager.instance,
    );
  }
}
