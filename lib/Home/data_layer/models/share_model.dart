class shareModel{
  final String groupLink;
  final String uCode;
  final String qrCode;
  shareModel({
    required this.groupLink,
    required this.uCode,
    required this.qrCode
});
  factory shareModel.fromJson(Map<String,dynamic> json){
    return shareModel(
      groupLink: json['groupLink'] ?? '',
      uCode: json['uCode'] ?? '',
      qrCode: json['qrCode'] ?? ''
    );
  }
}