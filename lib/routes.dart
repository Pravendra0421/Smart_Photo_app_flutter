import 'package:get/get.dart';
import 'onboarding/presentation_layer/bindings/onboarding_binding.dart'; // We will create this next
import 'onboarding/presentation_layer/screens/login_screen.dart'; // The UI screen
import 'onboarding/presentation_layer/screens/home_screen.dart'; // A placeholder home screen

class AppRoutes {
  static const LOGIN = '/login';
  static const HOME = '/home';
}

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginScreen(),
      binding: SmartAppBinding(), // Link the binding to the route
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeScreen(),
      // You can add a HomeBinding if needed
    ),
  ];
}