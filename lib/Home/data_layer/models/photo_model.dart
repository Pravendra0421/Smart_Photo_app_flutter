class PhotoModel{
  final String id;
  final String url;
  final String uploadedById;
  final String createdAt;
  PhotoModel({
    required this.id,
    required this.url,
    required this.uploadedById,
    required this.createdAt
});
  factory PhotoModel.fromJson(Map<String,dynamic> json){
    return PhotoModel(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      uploadedById: json['uploadedById'] ?? '',
      createdAt: json['createdAt'] ?? ''
    );
  }
}