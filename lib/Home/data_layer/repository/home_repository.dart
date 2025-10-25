import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/group_membership_model.dart';
import '../../../core/services/api_service.dart';
import '../models/groupDetail_model.dart';
import '../models/share_model.dart';
import 'dart:io';
class HomeRepository{
  final ApiService _apiService = ApiService();
  Future<List<GroupMembershipModel>> getUserGroup() async {
    try{
      final response = await _apiService.get("groupmembership/all");
      if(response.statusCode == 201){
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item)=>GroupMembershipModel.fromJson(item)).toList();
      }else{
        throw Exception('Failed to load groups. Status Code: ${response.statusCode}');
      }
    }catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
  Future<void> createGroupInApi(Map<String,dynamic> groupData) async{
    try{
      final response = await _apiService.post("Group/create", groupData);
      if(response.statusCode == 201){
        print("Group created SuccessFully on the server");
        return;
      }else{
        throw Exception('Failed to create group. Status: ${response.statusCode}, Body: ${response.body}');
      }
    }catch (e) {
      throw Exception('An error occurred while creating group: $e');
    }
  }
  Future<GroupDetailModel> getGroupDetails(String groupId) async {
    try{
      final response = await _apiService.get("Group/$groupId");
      if(response.statusCode == 201){
        final jsonData = json.decode(response.body);
        return GroupDetailModel.fromJson(jsonData);
      }else {
        throw Exception('Failed to load group details. Status: ${response.statusCode}');
      }
    }catch (e) {
      throw Exception('An error occurred while fetching group details: $e');
    }
  }
  Future<shareModel> getShareDetail(String groupId) async {
    try{
      final response = await _apiService.get("share-detail/$groupId");
      if(response.statusCode == 201){
        final jsonData = json.decode(response.body);
        return shareModel.fromJson(jsonData);
      }else {
        throw Exception('Failed to load group details. Status: ${response.statusCode}');
      }
    }catch (e) {
      throw Exception('An error occurred while fetching group details: $e');
    }
  }
  Future<void>joinGroup(Map<String,dynamic> Data) async{
    try{
      final response = await _apiService.post("groupmembership/add",Data);
      if(response.statusCode == 201){
        print("group join successfully");
        return;
      }else{
        throw Exception('Failed to create group. Status: ${response.statusCode}, Body: ${response.body}');
      }
    }catch (e) {
      throw Exception('An error occurred while creating group: $e');
    }
  }
  Future<void> uploadPhotos(String groupId, String imageUrl) async{
    try{
      final Map<String, dynamic> data = {
        'url': imageUrl,
      };
      final response = await _apiService.post("upload/$groupId", data);
      if(response.statusCode == 201){
        print("Image is Uploaded SuccessFully on the server");
        return;
      }else{
        throw Exception('Failed to create group. Status: ${response.statusCode}, Body: ${response.body}');
      }
    }catch (e) {
      throw Exception('An error occurred while creating group: $e');
    }
  }
}