import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/storage/storage_service.dart';
import 'core/bindings/initial_binding.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Staff Portal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialBinding: InitialBinding(),
      initialRoute: _getInitialRoute(),
      getPages: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }

  String _getInitialRoute() {
    return StorageService.hasToken ? AppRoutes.dashboard : AppRoutes.login;
  }
}