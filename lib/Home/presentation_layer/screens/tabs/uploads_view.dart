import 'package:flutter/material.dart';
import '../../../data_layer/models/photo_model.dart';

class UploadsView extends StatelessWidget {
  final List<PhotoModel> myUploads;
  const UploadsView({super.key, required this.myUploads});

  @override
  Widget build(BuildContext context) {
    if (myUploads.isEmpty) return const Center(child: Text("You haven't uploaded any photos."));

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
      itemCount: myUploads.length,
      itemBuilder: (context, index) {
        return Image.network(myUploads[index].url, fit: BoxFit.cover);
      },
    );
  }
}