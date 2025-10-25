import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
class joinGroupScreen extends StatelessWidget{
  const joinGroupScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      extendBodyBehindAppBar: true, // Allows body to go behind the transparent app bar
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Image Section (same as login screen)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
              child: Image.network(
                "https://res.cloudinary.com/ddguf7pkw/image/upload/v1760604428/4f20807aef016ec3efd46b38a554451e_tquu6q.jpg", // Replace with your image URL
                height: Get.height * 0.35,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(height: Get.height * 0.35, color: Colors.blueAccent),
              ),
            ),

            // OTP Verification Card
            Transform.translate(
              offset: const Offset(0, -50),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Camera Icon and Titles
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xFFE0EFFF),
                      child: Icon(Icons.camera_alt, color: Color(0xFF3A86FF), size: 30),
                    ),
                    const SizedBox(height: 8),
                    const Text("Let's Join ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    const SizedBox(height: 24),

                    // OTP Input Fields
                    _buildOtpFields(context),
                    const SizedBox(height: 16),

                    // Resend Timer

                    const SizedBox(height: 24),

                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value ? null : () => controller.JoinGroup(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3A86FF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Continue", style: TextStyle(fontSize: 16, color: Colors.white)),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for the 6 OTP input boxes
  Widget _buildOtpFields(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    // This defines the style for each box
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 55,
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    return Pinput(
      length: 6,
      controller: controller.JoinCodeController,
      keyboardType: TextInputType.visiblePassword,
      autofocus: true,// allow text input (letters + numbers)
      textCapitalization: TextCapitalization.characters,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')), // Allow letters (a-z, A-Z) and numbers (0-9)
        LengthLimitingTextInputFormatter(6), // Optional: Limit input to 6 characters
      ],
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(color: const Color(0xFF3A86FF)),
        ),
      ),
      onChanged: (value) {
        print('Current code: $value');
      },
      onCompleted: (pin) {
        print('Code Completed: $pin');
        controller.JoinGroup();
      },
    );
  }
}