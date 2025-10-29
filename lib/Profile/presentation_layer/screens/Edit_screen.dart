import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../controllers/Profile_controller.dart';
class EditProfileScreen extends StatelessWidget{
  const EditProfileScreen({super.key});
  @override
  Widget build(BuildContext context){
    final ProfileController controller =Get.find();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()=>Get.back(), icon: const Icon(Icons.arrow_back)),
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              "It is mandatory as it will be used for facial recognition to find your photos from groups",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Obx((){
              ImageProvider<Object>? backgroundImage;
              File? imageFile = controller.newProfileImageFile.value;
              String? imageUrl = controller.profileData.value?.imageUrl;

              if (imageFile != null) {
                backgroundImage = FileImage(imageFile);
              }
              // Check specifically if imageUrl is not null AND not empty
              else if (imageUrl != null && imageUrl.isNotEmpty) {
                // We know imageUrl is a valid String here
                backgroundImage = NetworkImage(imageUrl);
              }
              else {
                backgroundImage = null; // Use placeholder
              }
              return Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: backgroundImage,
                    backgroundColor: Colors.grey[200],
                    child: backgroundImage == null ? const Icon(Icons.person,size: 60,):null,
                  ),
                  GestureDetector(
                    onTap: () {
                      _showImageSourceDialog(context, controller);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 10),
            // You can add the "Verified" text if needed
            const Text("Verified", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            _buildTextField(controller: controller.firstNameController, label: "First name"),
            const SizedBox(height: 16),
            _buildTextField(controller: controller.lastNameController, label: "Last Name"),
            const SizedBox(height: 16),
            _buildTextField(controller: controller.emailController, label: "Email", keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            // Phone Number (Display Only)
            TextField(
              controller: TextEditingController(text: controller.profileData.value?.phoneNumber ?? 'N/A'),
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Padding(padding: EdgeInsets.all(15.0), child: Text('+91')), // Adjust if needed
              ),
              readOnly: true, // Make it non-editable
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isSaving.value ? null : controller.updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: controller.isSaving.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Continue", style: TextStyle(fontSize: 16)),
              )),
            ),
          ],
        ),
      ),
    );
  }
  // Helper for text fields
  Widget _buildTextField({required TextEditingController controller, required String label, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context, ProfileController controller) {
    Get.defaultDialog(
      title: "Change Profile Picture",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Take a Selfie"),
            onTap: () {
              Get.back(); // Close the dialog
              controller.navigateToTakeSelfie(); // Navigate to Selfie screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Choose from Gallery"),
            onTap: () {
              Get.back(); // Close the dialog
              controller.pickProfileImageFromGallery(); // Pick from gallery
            },
          ),
        ],
      ),
    );
  }
}