import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
class StorageService {
  // final FirebaseStorage _storage = FirebaseStorage.instance;
  final CloudinaryPublic cloudinary = CloudinaryPublic(
    'ddhgvmdg9', // <-- Replace with your Cloud Name from the dashboard
    'ml_default', // <-- Replace with the Upload Preset name you just configured
    cache: false,
  );
  Future<String?> uploadFile(File file,String path) async {
    // try{
    //   final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
    //   final String fullPath = '$path/$fileName';
    //   final Reference ref = _storage.ref().child(fullPath);
    //   final UploadTask uploadTask = ref.putFile(file);
    //   final TaskSnapshot snapshot = await uploadTask;
    //   final String downloadUrl = await snapshot.ref.getDownloadURL();
    //   return downloadUrl;

    try{
      print("Uploading to cloudinary....");
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          resourceType: CloudinaryResourceType.Auto, // This detects if it's an image or video
          folder: path, // e.g., 'group_images'
        ),
      );
      if (response.secureUrl != null && response.secureUrl!.isNotEmpty) {
        print("File uploaded successfully. URL: ${response.secureUrl}");
        return response.secureUrl;
      }
    }catch (e) {
      print("File Upload Error: $e");
      return null;
    }
  }
}