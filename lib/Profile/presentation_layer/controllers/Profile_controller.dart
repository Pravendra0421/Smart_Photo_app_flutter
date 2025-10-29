import '../../data_layer/models/profile_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data_layer/repository/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../routes.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/auth_service.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
class ProfileController extends GetxController{
    final ProfileRepository repository = ProfileRepository();
    final StorageService _storageService = StorageService();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final AuthService _authService =Get.find<AuthService>();
    var isLoading =true.obs;
    var isSaving =false.obs;
    var profileData = Rx<ProfileModel?>(null);

    late TextEditingController firstNameController;
    late TextEditingController lastNameController;
    late TextEditingController emailController;
    var newProfileImageFile = Rx<File?>(null);

    @override
    void onInit(){
        super.onInit();
        firstNameController = TextEditingController();
        lastNameController = TextEditingController();
        emailController = TextEditingController();
        fetchProfileDetail();
    }
    @override
    void onClose() {
        // Dispose controllers to prevent memory leaks
        firstNameController.dispose();
        lastNameController.dispose();
        emailController.dispose();
        super.onClose();
    }
    Future<void> fetchProfileDetail () async{
        try{
            isLoading.value = true;
            final detail = await repository.profileRepo();
            profileData.value =detail;
            // After fetching, populate the controllers for the edit screen
            _initializeEditControllers();
        }catch (e) {
            Get.snackbar("Error", "Could not load Profile details.");
        } finally {
            isLoading.value = false;
        }
    }
     void _initializeEditControllers(){
        if(profileData.value != null){
            firstNameController.text = profileData.value!.firstName ?? '';
            lastNameController.text = profileData.value!.lastName ?? '';
            emailController.text = profileData.value!.email ?? '';
            newProfileImageFile.value = null;
        }
     }
    void pickProfileImageFromGallery() async {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
            newProfileImageFile.value = File(image.path);
        }
    }
     void navigateToTakeSelfie()async{
        final result = await Get.toNamed(AppRoutes.TAKESELFIE);
        if(result is File){
            print("Selfie captured, processing (face detection placeholder)...");
            bool faceDetected = await _detectFace(result);
            if (faceDetected) {
                newProfileImageFile.value = result;
                Get.snackbar("Success", "Selfie accepted!");
            } else {
                Get.snackbar("Error", "No face detected or image unsuitable. Please try again.");
            }
        }
     }
     Future<void> updateProfile() async{
        if(profileData.value == null) return;
        isSaving.value = true;
        String? finalImageUrl = profileData.value!.imageUrl;
        try{
            if(newProfileImageFile.value != null){
                print("uploading new Profile image");
                finalImageUrl = await _storageService.uploadFile(newProfileImageFile.value!, 'profile_picture');
                if(finalImageUrl == null){
                    throw Exception("Image upload failed.");
                }
                print("New image uploaded: $finalImageUrl");
            }
            Map<String,dynamic> updateData ={
                'firstName':firstNameController.text.trim(),
                'lastName':lastNameController.text.trim(),
                'email': emailController.text.trim().isEmpty ? null : emailController.text.trim(),
                'imageUrl':finalImageUrl
            };
            final bool success = await repository.updateProfileRepo(updateData);
            if(success){
                await fetchProfileDetail();
                Get.back();
                Get.snackbar("Success", "Profile updated successfully!");
            }else {
                throw Exception("Server failed to update profile.");
            }
        } catch (e) {
            Get.snackbar("Error", "Failed to update profile: ${e.toString()}");
        } finally {
            isSaving.value = false;
        }
     }

    Future<bool> _detectFace(File imageFile) async {
        try {
            final options = FaceDetectorOptions(); // Use default options
            final faceDetector = FaceDetector(options: options);
            final inputImage = InputImage.fromFilePath(imageFile.path);

            final List<Face> faces = await faceDetector.processImage(inputImage);
            await faceDetector.close(); // Important to release resources

            if (faces.length == 1) {
                print("Face detected!");
                // Optional: Add checks for bounds, landmarks, etc.
                // final face = faces.first;
                // Check if face.boundingBox covers a significant portion of the image
                return true;
            } else {
                print("Incorrect number of faces detected: ${faces.length}");
                return false;
            }
        } catch (e) {
            print("Error during face detection: $e");
            return false;
        }
    }

    void SignOutController () async{
        try{
            isLoading.value = true;

        }catch (e) {
            Get.snackbar("Error", "Could not load Profile details.");
        } finally {
            isLoading.value = false;
        }
    }
}