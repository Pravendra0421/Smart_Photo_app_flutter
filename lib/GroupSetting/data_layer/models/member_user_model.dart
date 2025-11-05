class MemberUserModel {
  final String id;
  final String uid;
  final String? email;
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? imageUrl;

  MemberUserModel({
    required this.id,
    required this.uid,
    this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.imageUrl
});
  String get displayName {
    if(firstName != null && firstName!.isNotEmpty){
      return '$firstName $lastName'.trim();
    }
    return phoneNumber ?? 'KwicPic User';
  }
  factory MemberUserModel.fromJson(Map<String,dynamic> json){
    return MemberUserModel(
      id: json['id'] ?? '',
      uid: json['uid'] ?? '',
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      imageUrl: json['imageUrl'],
    );
  }
}