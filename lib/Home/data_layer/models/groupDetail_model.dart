import 'photo_model.dart';
class GroupDetailModel{
  final String id;
  final String name;
  final List<PhotoModel> photos;
  GroupDetailModel({
    required this.id,
    required this.name,
    required this.photos
});
  factory GroupDetailModel.fromJson(Map<String,dynamic>json){
    var photoListFromJson = json['photos'] as List? ?? [];
    List<PhotoModel> parsedPhotos = photoListFromJson.map((photojson)=>PhotoModel.fromJson(photojson)).toList();
    return GroupDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      photos: parsedPhotos
    );
  }
}