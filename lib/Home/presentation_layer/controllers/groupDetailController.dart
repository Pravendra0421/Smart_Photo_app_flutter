import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:collection/collection.dart';
import '../../data_layer/models/photo_model.dart';
import '../../data_layer/models/groupDetail_model.dart';
import '../../data_layer/repository/home_repository.dart';
import '../../data_layer/repository/auth_repository.dart';
import '../../../core/services/auth_service.dart';
class GroupDetailController extends GetxController with GetSingleTickerProviderStateMixin{
  final HomeRepository repository = HomeRepository();
  final String groupId;
  GroupDetailController({required this.groupId});
  late TabController tabController;
  var isLoading =true.obs;
  var groupDetails = Rx<GroupDetailModel?>(null);
  var photosByDate = <String, List<PhotoModel>>{}.obs;
  var myUploads = <PhotoModel>[].obs;
  @override
  void onInit(){
    super.onInit();
    tabController = TabController(length: 4,vsync: this);
    fetchGroupDetails();
  }
  void fetchGroupDetails() async{
    try{
      isLoading.value = true;
      final details = await repository.getGroupDetails(groupId);
      groupDetails.value = details;
      _processPhotos(details.photos);
    }catch (e) {
      Get.snackbar("Error", "Could not load group details.");
    } finally {
      isLoading.value = false;
    }
  }
  void _processPhotos(List<PhotoModel> allPhotos) {
    final AuthService authService = Get.find<AuthService>();
    final String? currentUserDbId = authService.currentUser.value?.id;
    if(currentUserDbId != null){
        myUploads.value = allPhotos.where((p)=>p.uploadedById == currentUserDbId).toList();
      }
      photosByDate.value = groupBy(allPhotos, (PhotoModel p) => p.createdAt.split('T')[0]);
  }
  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}