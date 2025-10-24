import 'group_model.dart';
class GroupMembershipModel {
  final String id;
  final String role;
  final GroupModel group;
  GroupMembershipModel({required this.id , required this.role, required this.group});
  factory GroupMembershipModel.fromJson(Map<String , dynamic> json){
    return GroupMembershipModel(
      id: json['id'] ?? '',
      role: json['role'] ?? 'MEMBER',
      group: GroupModel.fromJson(json['group']),
    );
  }
}