import 'profile_count_model.dart';
class ProfileModel{
  final String id;
  final String uid;
  final String? email;
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? imageUrl;
  final ProfileCounts counts;
  ProfileModel({required this.id,required this.uid,required this.email,required this.phoneNumber,required this.firstName,required this.lastName,required this.imageUrl , required this.counts,});
  factory ProfileModel.fromJson(Map<String,dynamic>json){
    return ProfileModel(
        id: json['id'] ?? "",
        uid: json['uid'] ?? "",
        email: json['email'] ?? "",
        phoneNumber: json['phoneNumber'] ?? "",
        firstName: json['firstName'] ?? "",
        lastName: json['lastName'] ?? "",
        imageUrl: json['imageUrl'] ?? "",
      counts: ProfileCounts.fromJson(json['_count'] ?? {}),
    );
  }
}