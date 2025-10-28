import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Home/presentation_layer/controllers/navigation_controller.dart';
import 'Home/presentation_layer/screens/home_screen.dart';
import 'Profile/presentation_layer/screens/profile_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);
  final NavigationController controller = Get.put(NavigationController());
  final List<Widget>screens =[
    HomeScreen(),
    // MyPhotoScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context){
    return Obx(()=> Scaffold(
      body: screens[controller.selectedIndex.value],
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
        // BottomNavigationBarItem(
        //     icon: Icon(Icons.photo_library), label: 'My Photo'),
        BottomNavigationBarItem(icon: Icon(Icons.person),label: 'My Profile'),
      ],
      currentIndex: controller.selectedIndex.value,
        onTap: controller.changeIndex,
      ),
    ));
  }
}