import 'package:flutter/material.dart';
import 'package:get/get.dart';
class EditProfileScreen extends StatelessWidget{
  const EditProfileScreen({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()=>Get.back(), icon: const Icon(Icons.arrow_back)),
      ),
    );
  }
}