import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data_layer/models/onboardingModel.dart';
import '../../data_layer/repository/onboarding_main_repository.dart';
import '../../../routes.dart';
class OnboardingController extends GetxController {
  final OnboardingRepository repository;
  OnboardingController({required this.repository});
  final pageController = PageController();
  var currentPageIndex = 0.obs;
  final RxList<OnboardingModel> onboardingPages = <OnboardingModel>[].obs;
  final RxBool isLoading = true.obs;
  @override
  void onInit(){
    super.onInit();
    fetchData();
  }
  void fetchData() async {
    try{
      isLoading.value = true;
      var data = await repository.getOnboardingData();
      onboardingPages.assignAll(data);
    }catch (e) {
      Get.snackbar("Error", "Onboarding data getching error");
    } finally {
      isLoading.value = false;
    }
  }
  void nextPage(){
    if(currentPageIndex.value == onboardingPages.length -1 ){
      Get.offAllNamed(AppRoutes.PHONELOGIN);
    }else{
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }
}