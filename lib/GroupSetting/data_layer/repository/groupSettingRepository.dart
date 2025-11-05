import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/services/api_service.dart';
import '../models/group_member_model.dart';
import '../models/member_group_info_model.dart';
import '../models/registered_contact_model.dart';
import 'dart:io';
class GroupSettingRepository{
  final ApiService _apiService = ApiService();
  Future<List<GroupMemberModel>> getGroupMembers(String groupId) async {
    try{
      final response = await _apiService.get('groupmembership/$groupId');
      if(response.statusCode == 201){
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => GroupMemberModel.fromJson(item)).toList();
      }else{
        throw Exception("Failed to load members. Status: ${response.statusCode}");
      }
    }catch (e) {
      throw Exception("Error in getGroupMembers: $e");
    }
  }
  Future<List<RegisteredContactModel>> checkRegisteredContacts(List<String> phoneNumbers) async{
    try{
      final response = await _apiService.post('user/check-contacts', {
        'phoneNumbers':phoneNumbers
      });
      if(response.statusCode == 201){
        List<dynamic>jsonData = json.decode(response.body);
        return jsonData.map((item)=>RegisteredContactModel.fromJson(item)).toList();
      }else{
        throw Exception("Failed to check contacts. Status: ${response.statusCode}");
      }
    }catch(e){
      throw Exception("Error in checkRegisteredContacts: $e");
    }
  }
  Future<int> addMultipleMembersToGroup({
    required String groupId,
    required List<String> userIdsToAdd,
  })async {
    try{
      final response = await _apiService.post('groupmembership/add-members',{
        "groupId":groupId,
        "userIdsToAdd":userIdsToAdd
      });
      if(response.statusCode == 201){
        final Map<String ,dynamic> data = json.decode(response.body);
        return data['count'] ?? 0;
      }else {
        throw Exception("Failed to add members. Status: ${response.statusCode}");
      }
    }catch (e) {
      throw Exception(e.toString());
    }
  }
}