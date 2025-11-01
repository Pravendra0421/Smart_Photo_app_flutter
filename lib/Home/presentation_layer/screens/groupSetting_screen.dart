import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/groupDetailController.dart';
class GroupSettingScreen extends StatelessWidget{
  const GroupSettingScreen({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        leading: IconButton(onPressed:() => Get.back(), icon: const Icon(Icons.arrow_back)),
      ),
    );
  }
}