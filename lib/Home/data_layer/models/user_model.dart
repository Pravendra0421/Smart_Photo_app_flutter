class UserModel{
  final String id;
  final String uid;
  final String? email;
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? imageUrl;
  UserModel({required this.id,required this.uid,required this.email,required this.phoneNumber,required this.firstName,required this.lastName,required this.imageUrl});
  factory UserModel.fromJson(Map<String,dynamic>json){
    return UserModel(
      id: json['id'] ?? "",
      uid: json['uid'] ?? "",
      email: json['email'] ?? "",
      phoneNumber: json['phoneNumber'] ?? "",
      firstName: json['firstName'] ?? "",
      lastName: json['lastName'] ?? "",
      imageUrl: json['imageUrl'] ?? ""
    );
  }
}