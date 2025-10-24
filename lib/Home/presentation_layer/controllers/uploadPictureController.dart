import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data_layer/repository/home_repository.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/storage_service.dart';
import 'dart:io';
import 'groupDetailController.dart';
class UploadPictureController extends GetxController{
  final HomeRepository repository = HomeRepository();
  final StorageService _storageService = StorageService();
  final String groupId;
  UploadPictureController({required this.groupId});
  var isLoading = false.obs;
  var uploadImageFile = Rx<File?>(null);

  void pickUploadImage(ImageSource source) async{
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        uploadImageFile.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar("Error", "Could not pick image: $e");
    }
  }
  void uploadPicture() async{
    if(uploadImageFile.value == null){
      Get.snackbar("Error", "please select a image");
      return;
    }
    try{
      isLoading.value = true;
      final String? uploadedUrl = await _storageService.uploadFile(uploadImageFile.value!, 'uploadedImage');
      if (uploadedUrl == null) {
        throw Exception("Image upload failed. Please try again.");
      }
      final String imageUrl = uploadedUrl;
      await repository.uploadPhotos(groupId, imageUrl);
      Get.find<GroupDetailController>().fetchGroupDetails();
      Get.back();
      Get.snackbar("Success", "uploaded successfully");
    }catch (e) {
      Get.snackbar("Error", "Failed to create group: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

}