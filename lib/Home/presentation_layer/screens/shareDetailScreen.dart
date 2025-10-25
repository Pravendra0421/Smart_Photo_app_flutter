import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/share_detail_controller.dart';
// You MUST import the controller you intend to find;
import '../controllers/groupDetailController.dart';
class shareDetailScreen extends StatelessWidget {
  const shareDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GroupDetailController groupDetailController = Get.find();
    final String groupId = groupDetailController.groupId;
    final shareDetailController controller = Get.put(shareDetailController(groupId: groupId));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text("Share Group"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Obx(() {
        // Show loading indicator
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error message if data is null
        if (controller.shareDetail.value == null) {
          return const Center(child: Text("Could not load sharing details."));
        }

        // Show the main content
        final shareInfo = controller.shareDetail.value!;

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Share this group with your friends!",
                style: TextStyle(fontSize: 18, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Display the QR Code
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 8),
                  ],
                ),
                child:_buildQrImageFromDataUrl(shareInfo.qrCode),
              ),
              const SizedBox(height: 40),

              // Display the Unique Code (uCode)
              _buildInfoCard(
                title: "Or share this code",
                content: shareInfo.uCode,
                icon: Icons.copy_all_rounded,
                onIconTap: () {
                  Clipboard.setData(ClipboardData(text: shareInfo.uCode));
                  Get.snackbar("Copied!", "Group code copied to clipboard.");
                },
              ),
              const SizedBox(height: 20),

              // Display the Group Link
              _buildInfoCard(
                title: "Or share the link",
                content: shareInfo.groupLink,
                icon: Icons.share,
                onIconTap: () {
                  // For actual sharing, use the 'share_plus' package
                  Get.snackbar("Share", "Opening share dialog...");
                },
              ),
            ],
          ),
        );
      }),
    );
  }
  Widget _buildQrImageFromDataUrl(String dataUrl) {
    try {
      // 1. Find the comma to separate the header from the data
      final UriData? data = Uri.parse(dataUrl).data;
      if (data != null) {
        // 2. Decode the Base64 string into bytes
        final bytes = data.contentAsBytes();
        // 3. Use Image.memory to display the image from bytes
        return Image.memory(bytes, height: 200, width: 200);
      }
    } catch (e) {
      print("Error decoding QR Data URL: $e");
    }
    // If anything fails, show an error icon
    return const Icon(Icons.error, size: 50, color: Colors.grey);
  }
  // A reusable helper widget for displaying info with an action button
  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
    required VoidCallback onIconTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onIconTap,
            icon: Icon(icon, color: Colors.blueAccent),
          ),
        ],
      ),
    );
  }
}