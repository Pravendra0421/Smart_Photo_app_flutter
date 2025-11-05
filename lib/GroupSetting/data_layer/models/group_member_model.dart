import 'member_user_model.dart';
import 'member_group_info_model.dart';
class GroupMemberModel{
  final String id;
  final String role;
  final MemberUserModel user;
  final MemberGroupInfoModel group;

  GroupMemberModel({
    required this.id,
    required this.role,
    required this.user,
    required this.group
  });
  factory GroupMemberModel.fromJson(Map<String,dynamic> json){
    return GroupMemberModel(
      id: json['id'] ?? '',
      role: json['role'] ?? 'MEMBER',
      user: MemberUserModel.fromJson(json['user'] ?? {}),
      group: MemberGroupInfoModel.fromJson(json['group'] ?? {}),
    );
  }
}