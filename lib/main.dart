import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      initialRoute: AppRoutes.LOGIN,
      // Define all the pages
      getPages: AppPages.routes,
    );
  }
}