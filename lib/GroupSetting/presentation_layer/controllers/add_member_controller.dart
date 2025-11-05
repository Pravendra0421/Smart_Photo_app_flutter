import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart'; // openAppSettings yahan se aata hai
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../data_layer/repository/groupSettingRepository.dart';
import '../../data_layer/models/registered_contact_model.dart';
import 'group_settings_controller.dart';

class AddMemberController extends GetxController {
  final GroupSettingRepository repository = GroupSettingRepository();
  final String groupId;
  AddMemberController({required this.groupId});

  var isLoading = true.obs;
  var isAddingMembers = false.obs;

  var permissionStatus = Rx<PermissionStatus>(PermissionStatus.denied);

  var registeredContacts = <RegisteredContactModel>[].obs;
  var unregisteredContacts = <Contact>[].obs;
  var selectedUserIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    checkPermissionAndFetchContacts();
  }

  void navigateToAppSettings() async {
    await openAppSettings();
  }

  void checkPermissionAndFetchContacts() async {
    try {
      isLoading.value = true;
      var status = await Permission.contacts.status;
      permissionStatus.value = status;
      if (status == PermissionStatus.granted) {
        await fetchAndCrossReferenceContacts();
      } else {
        var requestedStatus = await Permission.contacts.request();
        permissionStatus.value = requestedStatus;

        if (requestedStatus == PermissionStatus.granted) {
          await fetchAndCrossReferenceContacts();
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Error checking permissions: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAndCrossReferenceContacts() async {
    try {
      isLoading.value = true;
      List<Contact> phoneContacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: false,
      );
      List<String> phoneNumbers = [];
      for (var contact in phoneContacts) {
        if (contact.phones.isNotEmpty) {
          String? phone = contact.phones.first.number;
          if (phone != null) {
            phoneNumbers.add(phone.replaceAll(" ", "").replaceAll("-", ""));
          }
        }
      }
      final registered = await repository.checkRegisteredContacts(phoneNumbers);
      registeredContacts.assignAll(registered);
      List<String> registeredPhones = registered.map((user) => user.phoneNumber ?? "").toList();
      unregisteredContacts.value = phoneContacts.where((contact) {
        if (contact.phones.isEmpty) return false;
        String? phone = contact.phones.first.number.replaceAll(" ", "").replaceAll("-", "");
        return phone.isNotEmpty && !registeredPhones.contains(phone);
      }).toList();
    } catch (e) {
      Get.snackbar("Error", "Could not load contacts: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSelection(String userId) {
    if (selectedUserIds.contains(userId)) {
      selectedUserIds.remove(userId);
    } else {
      selectedUserIds.add(userId);
    }
  }

  void confirmAddMembers() async {
    if (selectedUserIds.isEmpty) {
      Get.snackbar("No Selection", "Please select at least one member to add.");
      return;
    }
    try {
      isAddingMembers.value = true;
      int count = await repository.addMultipleMembersToGroup(
          groupId: groupId,
          userIdsToAdd: selectedUserIds.toList()
      );
      Get.back();
      Get.snackbar("Success", "$count new member(s) added!");
      Get.find<GroupSettingController>().fetchGroupMember();
    } catch (e) {
      Get.snackbar("Error", "Failed to add members: ${e.toString()}");
    } finally {
      isAddingMembers.value = false;
    }
  }

  void inviteMember(Contact contact) {
    Get.snackbar("Invite", "Sending invite to ${contact.displayName}...");
  }
}