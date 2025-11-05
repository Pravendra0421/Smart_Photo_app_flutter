class RegisteredContactModel{
  final String id;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String imageUrl;
  RegisteredContactModel({
    required this.id,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.imageUrl
  });
  String get displayName {
    if(firstName != null && firstName!.isNotEmpty){
      return '$firstName $lastName'.trim();
    }
    return phoneNumber ?? 'SmartPhotoApp';
  }
  factory RegisteredContactModel.fromJson(Map<String,dynamic> json){
    return RegisteredContactModel(
      id: json['id'],
      phoneNumber: json['phoneNumber'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      imageUrl: json['imageUrl']
    );
  }
}