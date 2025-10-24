import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data_layer/models/share_model.dart';
import '../../data_layer/repository/home_repository.dart';
import '../../../routes.dart';
class shareDetailController extends GetxController{
  final HomeRepository repository = HomeRepository();
  final String groupId;
  var isLoading = true.obs;
  var shareDetail = Rx<shareModel?>(null);
  shareDetailController({required this.groupId});
  @override
  void onInit(){
    super.onInit();
    fetchShareDetail();
  }
  void fetchShareDetail() async{
    try{
      isLoading.value = true;
      var Detail = await repository.getShareDetail(groupId);
      shareDetail.value = Detail;
    }catch (e) {
      Get.snackbar("Error", "Could not fetch your groups. Please try again.");
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}