import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/group_settings_controller.dart';
import '../../data_layer/models/member_group_info_model.dart';
import '../../../routes.dart';

class GroupSettingsScreen extends StatelessWidget {
  const GroupSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String groupId = Get.arguments as String;
    final GroupSettingController controller = Get.put(GroupSettingController(groupId: groupId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
        title: Obx(() => Text(controller.groupInfo.value?.name ?? "Loading...")),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.allMember.isEmpty) {
          return const Center(child: Text("No members found."));
        }

        final group = controller.groupInfo.value!;

        return ListView(
          children: [
            // --- Group Header ---
            _buildGroupHeader(group),

            // --- Settings Options ---
            _buildSettingsList(),

            // --- Participants List ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Add Participants: ${controller.allMember.length}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                      Obx(() {
                        // Role check karo
                        String role = controller.currentUserRole.value;
                        if (role == 'ADMIN' || role == 'OWNER') {
                          return IconButton(
                            icon: const Icon(Icons.add_circle, color: Colors.blue, size: 30),
                            onPressed: () {
                              Get.toNamed(AppRoutes.ADDMEMBER, arguments: groupId);
                            },
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                      // ===== END OF LOGIC =====
                    ],
                  ),
                ],
              ),
            ),

            // --- Member List ---
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.allMember.length,
              itemBuilder: (context, index) {
                final member = controller.allMember[index];
                final bool isOwner = member.group.ownerId == member.user.id;
                final bool isAdmin = member.role == 'ADMIN' || isOwner;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: (member.user.imageUrl != null && member.user.imageUrl!.isNotEmpty)
                        ? NetworkImage(member.user.imageUrl!) : null,
                    child: (member.user.imageUrl == null || member.user.imageUrl!.isEmpty)
                        ? Text(member.user.displayName[0].toUpperCase()) : null,
                  ),
                  title: Text(member.user.displayName),
                  subtitle: Text(member.user.phoneNumber ?? "No phone"),
                  trailing: isAdmin ? _buildAdminTag(isOwner: isOwner) : null,
                );
              },
            ),
          ],
        );
      }),
    );
  }

  // Helper Widgets
  Widget _buildGroupHeader(MemberGroupInfoModel group) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(radius: 40, backgroundImage: NetworkImage(group.imageUrl)),
              GestureDetector(
                onTap: () { /* Edit logic */ },
                child: const CircleAvatar(radius: 12, backgroundColor: Colors.blue, child: Icon(Icons.edit, size: 14, color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(group.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(group.privacyType, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        // You MUST add a color for the shadow to be visible
        color: Colors.white,

        // This was your existing code
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 3,  // How far the shadow spreads
            blurRadius: 5,   // How blurred the shadow is
            offset: Offset(0, 3), // Position of the shadow (x, y)
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(title: const Text("Mute"), leading: const Icon(Icons.volume_off_outlined), trailing: const Icon(Icons.arrow_forward_ios)),
          ListTile(title: const Text("Notification log"), leading: const Icon(Icons.notifications_outlined), trailing: const Icon(Icons.arrow_forward_ios)),
          ListTile(title: const Text("Settings"), leading: const Icon(Icons.settings_outlined), trailing: const Icon(Icons.arrow_forward_ios)),
        ],
      ),
    );
  }

  Widget _buildAdminTag({bool isOwner = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isOwner ? Colors.grey : Colors.blue),
      ),
      child: Text(
        isOwner ? "Admin" : "Admin",
        style: TextStyle(color: isOwner ? Colors.grey : Colors.blue, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}