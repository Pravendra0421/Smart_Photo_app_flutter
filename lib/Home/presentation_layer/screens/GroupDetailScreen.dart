import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/groupDetailController.dart';
import 'tabs/date_view.dart';
import 'tabs/uploads_view.dart';
import 'tabs/folders_view.dart';

class GroupDetailScreen extends StatelessWidget {
  const GroupDetailScreen({super.key});

  @override
  Widget build (BuildContext context){
    final String groupId = Get.arguments as String;
    final GroupDetailController controller = Get.put(GroupDetailController(groupId:groupId));
    return Scaffold(
      appBar: AppBar(
        title: Obx(()=>Column(
          children: [
            Text(controller.groupDetails.value?.name ?? "Loading..."),
            if (!controller.isLoading.value && controller.groupDetails.value != null)
              Text("${controller.groupDetails.value!.photos.length} Photos", style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        )),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
        bottom: TabBar(
            controller: controller.tabController,
            isScrollable: true,
            tabs: const [
              Tab(text: "Date"),
              Tab(text: "Uploads"),
              Tab(text: "Folder"),
              Tab(text: "My Photos")
            ]),
      ),
      body: Obx((){
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.groupDetails.value == null) {
          return const Center(child: Text("Could not load details."));
        }
        return TabBarView(
          controller: controller.tabController,
          children: [
            DateView(photosByDate: controller.photosByDate),
            UploadsView(myUploads: controller.myUploads),
            const FoldersView(),
            const Center(child: Text("My Photos - Coming Soon!")),
          ],
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text("Upload Pics"),
        icon: const Icon(Icons.upload),
      ),
    );
  }
}