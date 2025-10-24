import 'package:get/get.dart';
import '../../data_layer/models/group_membership_model.dart';
import '../../data_layer/repository/home_repository.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
class HomeController extends GetxController{
  final HomeRepository repository = HomeRepository();
  final StorageService _storageService = StorageService();
  var isLoading = true.obs;
  var userGroups = <GroupMembershipModel>[].obs;

  // state for create Group Screen
  final groupNameController = TextEditingController();
  var selectedPrivacyType = 'PERSONAL'.obs;
  var groupImageFile = Rx<File?>(null);
  @override
  void onInit(){
    super.onInit();
    fetchUserGroups();
  }
  void fetchUserGroups() async {
    try{
      isLoading.value = true;
      var groups = await repository.getUserGroup();
      userGroups.assignAll(groups);
    }catch (e) {
      Get.snackbar("Error", "Could not fetch your groups. Please try again.");
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  // Placeholder functions for buttons
 void navigateToCreateGroup(){
    groupNameController.clear();
    selectedPrivacyType.value = 'PERSONAL';
    groupImageFile.value = null;
    Get.offAllNamed(AppRoutes.CREATEGROUP);
}
  void pickGroupImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      groupImageFile.value = File(image.path);
    }
  }
  void GetBack() async{
    Get.offAllNamed(AppRoutes.HOME);
  }
  void createNewGroup()async{
    if(groupNameController.text.trim().isEmpty){
      Get.snackbar("Error", "Please enter a group name.");
      return;
    }
    if(groupImageFile.value == null){
      Get.snackbar("Error", "Please select a group image.");
      return;
    }
    try{
      isLoading.value = true;
      String imageUrl;
      if (groupImageFile.value == null) {
        print("No image selected, using default URL.");
        imageUrl = "https://res.cloudinary.com/ddguf7pkw/image/upload/v1760703194/ChatGPT_Image_Oct_17_2025_05_42_29_PM_fcs2ii.png";

      } else {
        print("Image selected, uploading to Firebase Storage...");
        final String? uploadedUrl = await _storageService.uploadFile(
            groupImageFile.value!,
            'group_images'
        );

        if (uploadedUrl == null) {
          throw Exception("Image upload failed. Please try again.");
        }
        imageUrl = uploadedUrl;
      }
      Map<String,dynamic> groupData ={
        "name": groupNameController.text.trim(),
        "privacyType":selectedPrivacyType.value,
        "imageUrl":imageUrl
      };
      await repository.createGroupInApi(groupData);
      Get.back();
      Get.snackbar("success", "Group created successfully!");
      fetchUserGroups();
      Get.offAllNamed(AppRoutes.HOME);
    }catch (e) {
      Get.snackbar("Error", "Failed to create group: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
  void joinGroup() => print("Join Group Tapped!");
}