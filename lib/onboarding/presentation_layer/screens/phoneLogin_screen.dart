import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import 'otp_verification_screen.dart';
class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    // It's good practice to have a dedicated controller for authentication
    // final AuthController controller = Get.put(AuthController());
    final SmartAppController controller = Get.put(SmartAppController());

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8), // A light grey background
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Image Section
            _buildTopImage(),

            // White Card Section with form elements
            _buildAuthCard(controller),
          ],
        ),
      ),
    );
  }

  // Helper widget for the image at the top
  Widget _buildTopImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      child: Image.network(
        "https://res.cloudinary.com/ddguf7pkw/image/upload/v1760604428/4f20807aef016ec3efd46b38a554451e_tquu6q.jpg", // Replace with your image URL
        height: Get.height * 0.35,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Container(height: Get.height * 0.35, color: Colors.blueAccent),
      ),
    );
  }

  // Helper widget for the white authentication card
  Widget _buildAuthCard(SmartAppController controller) {
    return Transform.translate(
      offset: const Offset(0, -50), // Pulls the card up over the image
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
            // Camera Icon
            const CircleAvatar(
              radius: 30,
              backgroundColor: Color(0xFFE0EFFF),
              child: Icon(Icons.camera_alt, color: Color(0xFF3A86FF), size: 30),
            ),
            const SizedBox(height: 8),
            const Text("SIGN IN", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Welcome to Kwikpic", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            // Phone Number Input
            _buildPhoneNumberField(controller),
            const SizedBox(height: 24),

            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(
                    () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                    // On tap, send OTP and navigate to the next screen
                    controller.sendOtp();
                    Get.to(() => const OtpVerificationScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A86FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Continue", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // "Login with Email" Text
            // RichText(
            //   text: const TextSpan(
            //     style: TextStyle(color: Colors.grey),
            //     children: [
            //       TextSpan(text: "Sign up or Login Using "),
            //       TextSpan(
            //         text: "Email",
            //         style: TextStyle(color: Color(0xFF3A86FF), fontWeight: FontWeight.bold),
            //         // recognizer: TapGestureRecognizer()..onTap = () { ... }
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // Helper widget for the phone number input field
  Widget _buildPhoneNumberField(SmartAppController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Phone Number", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            // Country Code Dropdown

            // Number Input
            Expanded(
              child: TextField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "+911234567890",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
