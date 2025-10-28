import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/Profile_controller.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context){
    final ProfileController controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx((){
        if(controller.isLoading.value){
          return const Center(child: CircularProgressIndicator(),);
        }
        if(controller.profileData == null){
          return const Center(child: Text("Could not load profile details"),);
        }
        final profile = controller.profileData.value!;
        return Padding(
            padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        );
      }),
    );
  }
}