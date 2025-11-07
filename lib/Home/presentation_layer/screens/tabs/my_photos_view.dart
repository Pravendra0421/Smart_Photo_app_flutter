import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/groupDetailController.dart';
import '../../../../routes.dart';
import '../../../data_layer/models/photo_model.dart';
import 'dart:io';
class MyPhotosView extends StatelessWidget {
  const MyPhotosView({super.key});

  @override
  Widget build(BuildContext context) {
    final GroupDetailController controller = Get.find();

    return Obx(() {
      if (controller.isMatchingPhotos.value) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Finding your photos..."),
            ],
          ),
        );
      }
      if (controller.myMatchedPhoto.isEmpty) {
        return const Center(
          child: Text("We couldn't find any photos of you in this group."),
        );
      }
      return GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: controller.myMatchedPhoto.length,
        itemBuilder: (context, index) {
          final photo = controller.myMatchedPhoto[index];
          return GestureDetector(
            onTap: (){
              final List<PhotoModel> allPhotos = controller.groupDetails.value!.photos;
              final int initialIndex = allPhotos.indexWhere((p)=>p.id == photo.id);
              if (initialIndex == -1) {
                Get.snackbar("Error", "Could not find this photo.");
                return;
              }
              Get.toNamed(
                AppRoutes.IMAGEPAGER,
                arguments: {
                  'photos':allPhotos,
                  'index':initialIndex,
                }
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                photo.url,
                fit: BoxFit.cover,
                errorBuilder: (context,error,stackTrace){
                  return const Icon(Icons.broken_image, color: Colors.grey);
                },
              ),
            ),
          );
        },
      );
    });
  }
}