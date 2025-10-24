import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/uploadPictureController.dart';
import '../../controllers/groupDetailController.dart';
import 'package:image_picker/image_picker.dart';
class UploadOptionsSheet extends StatelessWidget{
  const UploadOptionsSheet({super.key});
  @override
  Widget build(BuildContext context) {
    final GroupDetailController groupDetailController = Get.find();
    final UploadPictureController uploadController = Get.put(
      UploadPictureController(groupId: groupDetailController.groupId),
    );
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      child: Wrap(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Upload", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(onPressed: ()=>Get.back(), icon: const Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            children: [
              Expanded(child: _buildOptionCard(icon:Icons.camera_alt_outlined , label:"Camera",onTap: () {
                uploadController.pickUploadImage(ImageSource.camera);
              },)),
              const SizedBox(width: 16),
              Expanded(child: _buildOptionCard(icon:Icons.photo_library_outlined, label:"Gallery",onTap: () {
                uploadController.pickUploadImage(ImageSource.gallery);
              },)),

            ],
          ),
          const SizedBox(height: 30),
          const Text("Upload using these links", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLinkIcon(Icons.drive_eta), // Placeholder for Google Drive
              _buildLinkIcon(Icons.cloud_queue), // Placeholder for Dropbox
              _buildLinkIcon(Icons.cloud), // Placeholder for OneDrive
              _buildLinkIcon(Icons.play_circle_fill), // Placeholder for YouTube
            ],
          ),
          const SizedBox(height: 20),
          // 4. Insert Link TextField
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.link),
              hintText: "Insert Link here",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),
          // 5. Add Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: uploadController.uploadPicture,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F80ED),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Add", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildOptionCard({required IconData icon, required String label,required VoidCallback onTap}) {
    final UploadPictureController controller = Get.find();
    return GestureDetector(
      onTap:onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.grey[700]),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  // Helper widget for link icons
  Widget _buildLinkIcon(IconData icon) {
    return IconButton(
      onPressed: () {},
      icon: Icon(icon, size: 35, color: Colors.grey[600]),
    );
  }

}