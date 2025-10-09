import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the instance of the controller that was created by the binding
    final SmartAppController controller = Get.find<SmartAppController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone Authentication"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          // Obx widget rebuilds its child when any of its reactive variables change
          child: Obx(
                () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Enter your phone number to login or register",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 30),

                // Phone Number Text Field
                TextField(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    hintText: "+91 98765 43210",
                    border: OutlineInputBorder(),
                  ),
                  // Disable the field after OTP is sent
                  enabled: !controller.isOtpSent.value,
                ),
                const SizedBox(height: 20),

                // Conditionally show OTP field
                if (controller.isOtpSent.value)
                  TextField(
                    controller: controller.otpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "6-Digit OTP",
                      border: OutlineInputBorder(),
                    ),
                  ),
                const SizedBox(height: 30),

                // Login/Verify Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    // Disable button while loading
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                      // Call a different function based on the state
                      if (controller.isOtpSent.value) {
                        controller.verifyOtpAndLogin();
                      } else {
                        controller.sendOtp();
                      }
                    },
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                    // Change button text based on the state
                        : Text(controller.isOtpSent.value ? "Verify & Login" : "Send OTP"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}