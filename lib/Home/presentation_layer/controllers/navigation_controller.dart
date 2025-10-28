import 'package:get/get.dart';

class NavigationController extends GetxController {
  // .obs makes this variable reactive (observable)
  var selectedIndex = 0.obs;

  // Function to change the index
  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}