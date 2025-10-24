import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart'; // The controller we created earlier
import '../controllers/onboarding_main_controller.dart';
import '../../data_layer/repository/onboarding_main_repository.dart';
class SmartAppBinding extends Bindings {
  @override
  void dependencies() {
    // Lazily create an instance of SmartAppController when the LoginScreen is loaded.
    Get.lazyPut<SmartAppController>(() => SmartAppController());
    Get.lazyPut<OnboardingRepository>(() => OnboardingRepository());
    Get.lazyPut<OnboardingController>(() => OnboardingController(repository: Get.find()));
  }
}