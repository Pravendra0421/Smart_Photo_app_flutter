import '../../data_layer/models/profile_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data_layer/repository/profile_repository.dart';
import '../../../routes.dart';
class ProfileController extends GetxController{
    final ProfileRepository repository = ProfileRepository();
    var isLoading =true.obs;
    var profileData = Rx<ProfileModel?>(null);
    @override
    void onInit(){
        super.onInit();
        fetchProfileDetail();
    }
    void fetchProfileDetail () async{
        try{
            isLoading.value = true;
            final detail = await repository.profileRepo();
            profileData.value =detail;
        }catch (e) {
            Get.snackbar("Error", "Could not load Profile details.");
        } finally {
            isLoading.value = false;
        }
    }
}