import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import '../../data_layer/models/photo_model.dart';
import '../../../Home/data_layer/repository/home_repository.dart';
import 'groupDetailController.dart';

class ImagePageController extends GetxController{
  final HomeRepository repository = HomeRepository();
  final List<PhotoModel> allPhotos;
  final int initialIndex;
  late PageController pageController;
  var currentIndex = 0.obs;
  var isDeleting =false.obs;
  var isDownloading = false.obs;
  ImagePageController({required this.allPhotos , required this.initialIndex});
  @override
  void onInit(){
    super.onInit();
    currentIndex.value = initialIndex;
    pageController =PageController(initialPage: initialIndex);
  }
  void onPageChanged(int index){
    currentIndex.value = index;
  }
  void deleteCurrentPhoto() async{
    isDeleting.value = true;
    try{
      final photoToDelete = allPhotos[currentIndex.value];
      await repository.DeletePhoto(photoToDelete.id);
      Get.back();
      final GroupDetailController detailController = Get.find();
      detailController.fetchGroupDetails();
      Get.snackbar(
          "Deleted",
          "Photo successfully deleted.",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1)
      );

    }catch (e) {
      Get.snackbar("Error", "Could not delete photo: ${e.toString()}");
    } finally {
      isDeleting.value = false;
    }
  }
  void downloadCurrentPhoto() async {
    isDownloading.value = true;
    try {
      PermissionStatus status;
      if (Platform.isAndroid && (await _getAndroidApiLevel() ?? 0) >= 33) {
        status = await Permission.photos.request(); // Android 13+
      } else {
        status = await Permission.storage.request(); // Old Android
      }

      if (Platform.isIOS) {
        status = await Permission.photos.request(); // iOS
      }

      if (status.isDenied || status.isPermanentlyDenied) {
        throw Exception("Storage/Photo permission denied.");
      }

      final photoToDownload = allPhotos[currentIndex.value];
      final String imageUrl = photoToDownload.url;

      final Directory tempDir = await getTemporaryDirectory();
      final String savePath = '${tempDir.path}/kwikpic_${photoToDownload.id}.jpg';

      await Dio().download(imageUrl, savePath);
      print("File downloaded to: $savePath");

      await Gal.putImage(savePath, album: 'Kwikpic');

      Get.snackbar("Success", "Image saved to Kwikpic album in gallery!");

    } catch (e) {
      Get.snackbar("Error", "Could not save image: ${e.toString()}");
      print("Download Error: $e");
    } finally {
      isDownloading.value = false;
    }
  }
  Future<int?> _getAndroidApiLevel() async {
    if (Platform.isAndroid) {
      //this will be come from 'device_info_plus' package show rightnow we can do hardcoded
      //we will use directly Permission.photos.request()
      return 33; // assume this is new phone
    }
    return null;
  }
}