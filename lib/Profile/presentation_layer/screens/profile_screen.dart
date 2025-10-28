import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/Profile_controller.dart';
import '../../data_layer/models/profile_model.dart';
import '../../data_layer/models/profile_count_model.dart';
import '../../../routes.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context){
    final ProfileController controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (String result) {
              switch (result) {
                case 'edit':
                  print('Edit selected');
                  Get.toNamed(AppRoutes.EDITSCREEN);
                case 'option2':
                  print('Option 2 selected');
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem<String>(
                value: 'option2',
                child: Text('Another Option'),
              ),
            ],
          ),
        ],
      ),
      body: Obx((){
        if(controller.isLoading.value){
          return const Center(child: CircularProgressIndicator(),);
        }
        if(controller.profileData == null){
          return const Center(child: Text("Could not load profile details"),);
        }
        final profile = controller.profileData.value!;
        return Padding(
            padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              _buildProfileHeader(profile),
              SizedBox(height: 10,),
              _buildStorageCard(profile.counts),
              SizedBox(height: 10,),
              _buildSubscriptionSection(),
              SizedBox(height: 10,),
              _buildSettingsList(),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text(
                    "Sign Out",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
  Widget _buildProfileHeader(dynamic profile){
    return Center(
      child:Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(profile.imageUrl),
          ),
          SizedBox(height: 15,),
          Text(
            profile.firstName,style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4,),
          Text(
            profile.phoneNumber,
            style: TextStyle(fontSize: 16,color: Colors.grey[700]),
          )
        ],
      ),
    );
  }
  Widget _buildStorageCard(ProfileCounts counts){
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFE9EFFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Storage Utilization",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStorageStat(Icons.image, "${counts.uploadPhoto}/1,000"),
              _buildStorageStat(Icons.videocam, "${counts.uploadVideo}/10")
            ],
          )
        ],
      ),
    );
  }
  Widget _buildStorageStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue[700]),
        SizedBox(width: 8),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }
  Widget _buildSubscriptionSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Subscription", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Text("Free - Active", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.workspace_premium_outlined),
          label: Text("Upgrade"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildSettingsList() {
    return Column(
      children: [
        _buildSettingsItem(Icons.people, "Close Friends"),
        _buildSettingsItem(Icons.download, "Auto- download"),
        _buildSettingsItem(Icons.settings, "App Settings"),
        _buildSettingsItem(Icons.security, "Privacy and Secrity", showArrow: true),
        _buildSettingsItem(Icons.help_outline, "Help and Support", showArrow: true),
      ],
    );
  }
  Widget _buildSettingsItem(IconData icon, String title, {bool showArrow = false}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.grey[800]),
      title: Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
      trailing: showArrow ? Icon(Icons.arrow_forward_ios, size: 10) : null,
      onTap: () {
        // Handle tap
      },
    );
  }
}