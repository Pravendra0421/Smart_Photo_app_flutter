import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart'; // The controller we created earlier

class SmartAppBinding extends Bindings {
  @override
  void dependencies() {
    // Lazily create an instance of SmartAppController when the LoginScreen is loaded.
    Get.lazyPut<SmartAppController>(() => SmartAppController());
  }
}