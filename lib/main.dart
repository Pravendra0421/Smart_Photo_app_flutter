import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'routes.dart';
import 'core/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "smart-photo-app",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use GetMaterialApp to enable GetX routing
    return GetMaterialApp(
      title: 'Smart App',
      debugShowCheckedModeBanner: false,
      // Set the initial route
      initialRoute: AppRoutes.ONBOARDING,
      // Define all the pages
      getPages: AppPages.routes,
    );
  }
}
