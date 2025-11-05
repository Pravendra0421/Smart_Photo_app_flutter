class MemberGroupInfoModel {
  final String id;
  final String name;
  final String privacyType;
  final String imageUrl;
  final String ownerId;

  MemberGroupInfoModel({
    required this.id,
    required this.name,
    required this.privacyType,
    required this.imageUrl,
    required this.ownerId,
  });

  factory MemberGroupInfoModel.fromJson(Map<String, dynamic> json) {
    return MemberGroupInfoModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      privacyType: json['privacyType'] ?? 'PUBLIC',
      imageUrl: json['imageUrl'] ?? '',
      ownerId: json['ownerId'] ?? '',
    );
  }
}