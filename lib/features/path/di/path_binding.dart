import 'package:fluency_app/core/di/injection_container.dart';
import 'package:fluency_app/features/path/domain/usecases/get_learning_path.dart';
import 'package:fluency_app/features/path/domain/usecases/reset_progress.dart';
import 'package:fluency_app/features/path/presentation/controller/path_controller.dart';
import 'package:get/get.dart';

class PathBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PathController>(
      () => PathController(
        getLearningPath: getIt<GetLearningPath>(),
        resetProgress: getIt<ResetProgress>(),
      ),
    );
  }
}
