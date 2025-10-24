import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../data_layer/repository/home_repository.dart';

class HomeAppBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut<HomeController>(()=>HomeController());
  }
}