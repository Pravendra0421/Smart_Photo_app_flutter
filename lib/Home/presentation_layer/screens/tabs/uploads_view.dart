import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data_layer/models/photo_model.dart';
import '../../controllers/groupDetailController.dart';
import '../../../../routes.dart';
class UploadsView extends StatelessWidget {
  final List<PhotoModel> myUploads;
  const UploadsView({super.key, required this.myUploads});

  @override
  Widget build(BuildContext context) {
    final GroupDetailController detailController = Get.find();
    if (myUploads.isEmpty) return const Center(child: Text("You haven't uploaded any photos."));

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
      itemCount: myUploads.length,
      itemBuilder: (context, index) {
        final photo =myUploads[index];
        return GestureDetector(
          onTap: (){
            final List<PhotoModel> allPhotos = detailController.groupDetails.value!.photos;
            final int initialIndex = allPhotos.indexWhere((p)=>p.id == photo.id);
            if (initialIndex == -1) {
              Get.snackbar("Error", "Could not find this photo.");
              return;
            }
            Get.toNamed(AppRoutes.IMAGEPAGER, arguments: {
              'photos': allPhotos,
              'index': initialIndex,
            },);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.network(
              photo.url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, color: Colors.grey);
              },
            ),
          ),
        );
      },
    );
  }
}