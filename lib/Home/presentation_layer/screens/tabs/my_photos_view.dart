import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/groupDetailController.dart';

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
          final imageUrl = controller.myMatchedPhoto[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, color: Colors.grey);
              },
            ),
          );
        },
      );
    });
  }
}