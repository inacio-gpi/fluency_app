import 'package:fluency_app/core/di/injection_container.dart';
import 'package:fluency_app/core/routes/app_pages.dart';
import 'package:fluency_app/core/routes/app_routes.dart';
import 'package:fluency_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initDependencies();
  runApp(const FluencyApp());
}

class FluencyApp extends StatelessWidget {
  const FluencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fluency',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.path,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
