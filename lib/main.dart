import 'package:file_manager/core/services/theme_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/constants/firebase_constants.dart';
import 'sign_up/controller/auth_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
    firebaseInitialization.then((value) {
    Get.put(AuthController());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme:ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeService().theme,
      home: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
