import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../data_layer/models/group_membership_model.dart';
import '../../../routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kwicpic",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_outlined, size: 28,),
            onPressed: () {},),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, size: 28,),
            onPressed: () {},),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(),);
        }
        if (controller.userGroups.isEmpty) {
          return const EmptyGroupScreen();
        } else {
          return FilledGroupScreen(groups: controller.userGroups);
        }
      }),
      // bottomNavigationBar: BottomNavigationBar(items: const [
      //   BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //   BottomNavigationBarItem(
      //       icon: Icon(Icons.photo_library), label: 'My Photo'),
      //   BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My Profile')
      // ]),
    );
  }
}

class EmptyGroupScreen extends StatelessWidget {
  const EmptyGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Hi John, you need to join or create a new group to get started. Let's take care of that first!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black54, height: 1.5),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: controller.navigateToCreateGroup,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: const Color(0xFF2F80ED),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Create Group",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
          const SizedBox(height: 20),
          const Text("Or", textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: controller.navigateToJoinGroup,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: const Color(0xFF2F80ED),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Join Group",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

class FilledGroupScreen extends StatelessWidget {
  final List<GroupMembershipModel> groups;

  const FilledGroupScreen({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Search Bar
        TextField(
          decoration: InputDecoration(
            hintText: "Search",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Groups",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            PopupMenuButton<String>(
              onSelected: (String result) {
                // Check which item was selected
                if (result == 'create') {
                  controller.navigateToCreateGroup();
                } else if (result == 'join') {
                  controller.navigateToJoinGroup();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'create',
                  child: ListTile(
                    leading: Icon(Icons.add_circle_outline),
                    title: Text('Create Group'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'join',
                  child: ListTile(
                    leading: Icon(Icons.group_add_outlined),
                    title: Text('Join Group'),
                  ),
                ),
              ],
              icon: const Icon(Icons.add_circle, color: Color(0xFF2F80ED), size: 32),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final groupData = groups[index].group; // Extract the GroupModel
            return GestureDetector(
                onTap: () {
                    Get.toNamed(AppRoutes.GROUPDETAIL,arguments: groupData.id);
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(groupData.imageUrl),
                      onBackgroundImageError: (exception,
                          stackTrace) => const Icon(Icons.error),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      groupData.name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ));
          },
        ),
      ],
    );
  }
}