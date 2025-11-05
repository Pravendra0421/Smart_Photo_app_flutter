import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/image_pager_controller.dart';
import '../../data_layer/models/photo_model.dart';
class ImagePagerScreen extends StatelessWidget{
  const ImagePagerScreen({super.key});
  @override
  Widget build(BuildContext context){
    final Map<String,dynamic> args = Get.arguments;
    final List<PhotoModel> photos = args['photos'];
    final int initialIndex = args['index'];
    final ImagePageController controller = Get.put(
      ImagePageController(allPhotos: photos, initialIndex: initialIndex),
    );
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(onPressed: ()=>Get.back(), icon: const Icon(Icons.arrow_back,color: Colors.white,)),
        actions: [
          Obx(() => controller.isDownloading.value
              ? const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(color: Colors.white),
          )
              : IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: controller.downloadCurrentPhoto,
          )),
        ],
      ),
      body: PageView.builder(
        controller: controller.pageController,
          itemCount: controller.allPhotos.length,
          onPageChanged: controller.onPageChanged,
          itemBuilder: (context,index){
            final photo = controller.allPhotos[index];
            return InteractiveViewer(
                panEnabled: true,
                minScale: 1.0,
                maxScale: 4.0,
                child: Image.network(
                  photo.url,
                  fit: BoxFit.contain,
                  loadingBuilder: (context,child,progress){
                    return progress == null ? child : const Center(child: CircularProgressIndicator(),);
                  },
                ),
            );
          },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Obx(()=>controller.isDeleting.value
        ? const Center(child: CircularProgressIndicator(),):IconButton(onPressed: (){
          Get.defaultDialog(
            title: "Delete Photo?",
            middleText: "Are you sure you want to delete this photo permanently?",
            textConfirm: "Delete",
            textCancel: "Cancel",
            confirmTextColor: Colors.white,
            onConfirm: () {
              Get.back();
              controller.deleteCurrentPhoto();
            },
          );
        }, icon: const Icon(Icons.delete_outline,color: Colors.redAccent,))
        ),
      ),
    );
  }
}