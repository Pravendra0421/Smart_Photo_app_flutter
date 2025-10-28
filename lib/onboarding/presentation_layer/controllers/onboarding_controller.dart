import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

// You will create this repository to handle communication with your backend.
import '../../data_layer/repository/onboarding_repository.dart';
// You will have your own routes file.
import '../../../routes.dart';
import '../../../core/services/auth_service.dart';
class SmartAppController extends GetxController {
  // Dependencies
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SmartAppRepository _repository = SmartAppRepository();

  // Text Controllers for the UI
  late TextEditingController phoneController;
  late TextEditingController otpController;

  // UI State Management
  var isLoading = false.obs;
  var isOtpSent = false.obs; // Use this to show/hide the OTP field
  var verificationId = ''.obs; // To store the verification ID from Firebase

  @override
  void onInit() {
    super.onInit();
    phoneController = TextEditingController();
    otpController = TextEditingController();
  }

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }

  /// Step 1: Sends an OTP to the user's phone number.
  Future<void> sendOtp() async {
    final phoneNumber = phoneController.text.trim();
    if (phoneNumber.isEmpty || phoneNumber.length < 10) {
      Get.snackbar("Invalid Phone Number", "Please enter a valid phone number with your country code (e.g., +91).");
      return;
    }

    isLoading.value = true;

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          // This is for auto-retrieval on Android.
          // You could automatically sign in the user here if needed.
          print("Phone number auto-verified.");
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar("Verification Failed", "Could not verify your phone number. ${e.message}");
          print("Firebase Verification Failed: ${e.code} - ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          // OTP has been sent, now show the OTP field in the UI
          this.verificationId.value = verificationId;
          isOtpSent.value = true;
          Get.snackbar("OTP Sent", "An OTP has been sent to $phoneNumber.");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Called when auto-retrieval has timed out.
        },
      );
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  /// Step 2: Verifies the OTP and handles both Login and Signup.
  Future<void> verifyOtpAndLogin() async {
    final otp = otpController.text.trim();
    if (otp.isEmpty || otp.length != 6) {
      Get.snackbar("Invalid OTP", "Please enter the 6-digit OTP you received.");
      return;
    }

    if (verificationId.value.isEmpty) {
      Get.snackbar("Error", "Something went wrong. Please try sending the OTP again.");
      return;
    }
    isLoading.value = true;
    try {
      // Create a credential using the OTP
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );

      // Sign in the user. Firebase handles if it's a new or existing user.
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        print("Firebase authentication successful. UID: ${user.uid}, Phone: ${user.phoneNumber}");
        final String? idToken = await user.getIdToken();
        if (idToken == null) {
          Get.snackbar("Error", "Authentication token is not found.");
          isLoading.value = false;
          return;
        }
        print("Firebase ID Token: $idToken");
        // Now, send the UID and phone number to your backend
        bool success = await _repository.loginOrRegisterUser(
          uid: user.uid,
          phoneNumber: user.phoneNumber!,
          token:idToken,
          // It's guaranteed to be non-null here
        );

        if (success) {
          print("Backend registration/login successful.");
          await Get.find<AuthService>().fetchAndSetCurrentUser();

          // Navigate to the home screen
          Get.offAllNamed(AppRoutes.MAINSCREEN);
        } else {
          Get.snackbar("Server Error", "Could not save your data. Please try again.");
        }
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Invalid OTP", "The OTP you entered is incorrect. Please try again.");
      print("FirebaseAuthException on OTP verification: ${e.code}");
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred during login.");
    } finally {
      isLoading.value = false;
    }
  }
}