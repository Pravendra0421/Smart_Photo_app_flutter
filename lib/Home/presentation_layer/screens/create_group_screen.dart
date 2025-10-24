import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: controller.GetBack
          ),
          title: const Text("Create a Group")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group Image and Name Section
            Row(
              children: [
                Obx(() => GestureDetector(
                  onTap: controller.pickGroupImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: controller.groupImageFile.value != null
                        ? FileImage(controller.groupImageFile.value!)
                        : null,
                    child: controller.groupImageFile.value == null
                        ? const Icon(Icons.camera_alt, size: 30, color: Colors.grey)
                        : null,
                  ),
                )),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: controller.groupNameController,
                    decoration: const InputDecoration(hintText: "Enter Group Name"),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Privacy Settings
            const Text("Privacy Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Obx(() => PrivacyOptionCard(
              title: "Small Personal Group",
              subtitle: "Members can see Personal Group",
              value: "PERSONAL",
              groupValue: controller.selectedPrivacyType.value,
              onChanged: (value) => controller.selectedPrivacyType.value = value!,
            )),
            const SizedBox(height: 12),
            Obx(() => PrivacyOptionCard(
              title: "Big Public Group",
              subtitle: "Members can see All photos",
              value: "PUBLIC",
              groupValue: controller.selectedPrivacyType.value,
              onChanged: (value) => controller.selectedPrivacyType.value = value!,
            )),
            const SizedBox(height: 40),

            // Create Group Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.createNewGroup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Create Group", style: TextStyle(fontSize: 16)),
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacyOptionCard extends StatelessWidget {
  final String title, subtitle, value, groupValue;
  final ValueChanged<String?> onChanged;
  const PrivacyOptionCard({super.key, required this.title, required this.subtitle, required this.value, required this.groupValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300, width: 2),
        ),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: Colors.grey[600]))
          ])),
          Radio<String>(value: value, groupValue: groupValue, onChanged: onChanged),
        ]),
      ),
    );
  }
}