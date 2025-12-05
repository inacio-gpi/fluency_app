import 'package:get_it/get_it.dart';

abstract class InjectionModule {
  Future<void> register(GetIt getIt);
}
