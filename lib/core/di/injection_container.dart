import 'package:fluency_app/core/di/core_injection.dart';
import 'package:fluency_app/core/di/injection_module.dart';
import 'package:fluency_app/features/lesson/di/lesson_injection.dart';
import 'package:fluency_app/features/path/di/path_injection.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  final modules = <InjectionModule>[
    CoreInjection(),
    PathInjection(),
    LessonInjection(),
  ];

  for (final module in modules) {
    await module.register(getIt);
  }
}

Future<void> addModule(InjectionModule module) async {
  await module.register(getIt);
}
