import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../controllers/add_member_controller.dart';
import '../../data_layer/models/registered_contact_model.dart';

class AddMemberScreen extends StatelessWidget {
  const AddMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String groupId = Get.arguments as String;
    final AddMemberController controller = Get.put(AddMemberController(groupId: groupId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Friends"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.permissionStatus.value == PermissionStatus.granted) {
          if (controller.registeredContacts.isEmpty && controller.unregisteredContacts.isEmpty) {
            return const Center(child: Text("No contacts found on your phone."));
          }
          return ListView(
            children: [
              if (controller.registeredContacts.isNotEmpty)
                _buildSectionHeader("Contacts on Kwikpic"),
              ...controller.registeredContacts.map((user) {
                return Obx(() => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: (user.imageUrl != null && user.imageUrl!.isNotEmpty)
                        ? NetworkImage(user.imageUrl!) : null,
                    child: (user.imageUrl == null || user.imageUrl!.isEmpty)
                        ? Text(user.displayName[0].toUpperCase()) : null,
                  ),
                  title: Text(user.displayName),
                  subtitle: Text(user.phoneNumber ?? ""),
                  trailing: controller.selectedUserIds.contains(user.id)
                      ? ElevatedButton(
                    onPressed: () => controller.toggleSelection(user.id),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text("Added"),
                  )
                      : ElevatedButton(
                    onPressed: () => controller.toggleSelection(user.id),
                    child: const Text("Add"),
                  ),
                ));
              }),
              if (controller.unregisteredContacts.isNotEmpty)
                _buildSectionHeader("Invite to Kwikpic"),
              ...controller.unregisteredContacts.map((contact) {
                return ListTile(
                  leading: CircleAvatar(child: Text(contact.displayName[0] ?? '?')),
                  title: Text(contact.displayName),
                  subtitle: Text(contact.phones.first.number ?? ""),
                  trailing: OutlinedButton(
                    child: const Text("Invite"),
                    onPressed: () => controller.inviteMember(contact),
                  ),
                );
              }),
            ],
          );
        }
        if (controller.permissionStatus.value == PermissionStatus.permanentlyDenied) {
          return _buildPermissionDeniedUI(
            controller,
            "Permission Permanently Denied",
            "To add members, Kwikpic needs to access your contacts. Please enable it in your phone's settings.",
            "Open Settings",
            controller.navigateToAppSettings, // FIX: Renamed function
          );
        }
        return _buildPermissionDeniedUI(
          controller,
          "Access Your Contacts",
          "We need your permission to find friends on Kwikpic.",
          "Grant Permission",
          controller.checkPermissionAndFetchContacts,
        );
        // --- END OF UI LOGIC ---
      }),
      floatingActionButton: Obx(() => controller.selectedUserIds.isEmpty
          ? const SizedBox.shrink()
          : FloatingActionButton.extended(
        onPressed: controller.isAddingMembers.value ? null : controller.confirmAddMembers,
        label: controller.isAddingMembers.value
            ? const CircularProgressIndicator(color: Colors.white)
            : Text("Add (${controller.selectedUserIds.length})"),
        icon: const Icon(Icons.check),
      )),
    );
  }
  Widget _buildPermissionDeniedUI(
      AddMemberController controller,
      String title,
      String message,
      String buttonText,
      VoidCallback onPressed
      ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.contact_phone_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            Text(title, style: Get.textTheme.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(message, textAlign: TextAlign.center, style: Get.textTheme.bodyMedium),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onPressed,
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}