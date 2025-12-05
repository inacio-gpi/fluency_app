import 'package:fluency_app/core/di/injection_module.dart';
import 'package:fluency_app/features/path/data/datasources/path_local_datasource.dart';
import 'package:fluency_app/features/path/data/datasources/path_mock_datasource.dart';
import 'package:fluency_app/features/path/data/repositories_impl/path_repository_impl.dart';
import 'package:fluency_app/features/path/domain/repositories/path_repository.dart';
import 'package:fluency_app/features/path/domain/usecases/get_learning_path.dart';
import 'package:fluency_app/features/path/domain/usecases/get_lesson.dart';
import 'package:fluency_app/features/path/domain/usecases/reset_progress.dart';
import 'package:fluency_app/features/path/domain/usecases/update_lesson_progress.dart';
import 'package:get_it/get_it.dart';

class PathInjection implements InjectionModule {
  @override
  Future<void> register(GetIt getIt) async {
    getIt.registerLazySingleton<PathMockDataSource>(
      () => PathMockDataSourceImpl(),
    );

    getIt.registerLazySingleton<PathLocalDataSource>(
      () => PathLocalDataSourceImpl(storageManager: getIt()),
    );

    getIt.registerLazySingleton<PathRepository>(
      () =>
          PathRepositoryImpl(mockDataSource: getIt(), localDataSource: getIt()),
    );

    getIt.registerLazySingleton(() => GetLearningPath(getIt()));
    getIt.registerLazySingleton(() => GetLesson(getIt()));
    getIt.registerLazySingleton(() => UpdateLessonProgress(getIt()));
    getIt.registerLazySingleton(() => ResetProgress(getIt()));
  }
}
