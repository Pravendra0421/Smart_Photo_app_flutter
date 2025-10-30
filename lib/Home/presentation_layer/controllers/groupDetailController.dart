import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:collection/collection.dart';
import '../../data_layer/models/photo_model.dart';
import '../../data_layer/models/groupDetail_model.dart';
import '../../data_layer/models/match_response_model.dart';
import '../../data_layer/repository/home_repository.dart';
import '../../data_layer/repository/auth_repository.dart';
import '../../../core/services/auth_service.dart';
import '../../../routes.dart';
class GroupDetailController extends GetxController with GetSingleTickerProviderStateMixin{
  final HomeRepository repository = HomeRepository();
  final String groupId;
  GroupDetailController({required this.groupId});
  late TabController tabController;
  var isLoading =true.obs;
  var groupDetails = Rx<GroupDetailModel?>(null);
  var photosByDate = <String, List<PhotoModel>>{}.obs;
  var myUploads = <PhotoModel>[].obs;
  var isMatchingPhotos = false.obs;
  var myMatchedPhoto =<String>[].obs;
  @override
  void onInit(){
    super.onInit();
    tabController = TabController(length: 4,vsync: this);
    fetchGroupDetails();
  }
  void navigateToShareDetail() async {
    Get.toNamed(AppRoutes.SHAREDETAIL);
  }
  void fetchGroupDetails() async{
    try{
      isLoading.value = true;
      final details = await repository.getGroupDetails(groupId);
      groupDetails.value = details;
      _processPhotos(details.photos);
       findMyPhotos(details.photos);
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
  Future<void> findMyPhotos(List<PhotoModel> allPhotos) async{
    try{
      isMatchingPhotos.value = true;
      final AuthService authService = Get.find<AuthService>();
      final String? selfieUrl = authService.currentUser.value?.imageUrl;
      if (selfieUrl == null || selfieUrl.isEmpty) {
        throw Exception("User profile image (selfie) not found.");
      }
      final List<String>allPhotoUrls = allPhotos.map((photo)=>photo.url).toList();
      final Map<String,dynamic> data ={
        "selfie":selfieUrl,
        "images":allPhotoUrls,
      };
      final MatchResponseModel matchResponse = await repository.getMatchedPhotos(data);
      myMatchedPhoto.assignAll(matchResponse.matches);
    }catch (e) {
      Get.snackbar("Face Match Error", "Could not find your photos: ${e.toString()}");
    } finally {
      isMatchingPhotos.value = false;
    }
  }
  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}