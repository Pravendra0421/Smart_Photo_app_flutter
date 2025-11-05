import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data_layer/models/photo_model.dart';
import '../../../../routes.dart';
import '../../controllers/groupDetailController.dart';
class DateView extends StatelessWidget {
  final Map<String, List<PhotoModel>> photosByDate;
  const DateView({super.key, required this.photosByDate});

  @override
  Widget build(BuildContext context) {
    final GroupDetailController detailController = Get.find();
    if (photosByDate.isEmpty) return const Center(child: Text("No photos in this group."));

    final dates = photosByDate.keys.toList();
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final date = dates[index];
        final photos = photosByDate[date]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(date, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8,
              ),
              itemCount: photos.length,
              itemBuilder: (context, photoIndex) {
                final photo = photos[photoIndex];{
                  return GestureDetector(
                    onTap: (){
                      final List<PhotoModel> allPhoto = detailController.groupDetails.value!.photos;
                      final int initialIndex = allPhoto.indexWhere((p)=>p.id == photo.id);
                      Get.toNamed(AppRoutes.IMAGEPAGER,arguments: {
                        'photos':allPhoto,
                        'index':initialIndex
                      });
                    },
                    child: Image.network(photo.url, fit: BoxFit.cover),
                  );
                }
                // return Image.network(photos[photoIndex].url, fit: BoxFit.cover);
              },
            ),
          ],
        );
      },
    );
  }
}