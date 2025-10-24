class GroupModel {
  final String id;
  final String name;
  final String imageUrl;
  GroupModel({required this.id,required this.name, required this.imageUrl});
  factory GroupModel.fromJson(Map<String, dynamic> json){
    return GroupModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? ''
    );
  }
}