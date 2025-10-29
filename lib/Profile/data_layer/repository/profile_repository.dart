import '../models/profile_model.dart';
import 'dart:convert';
import '../../../core/services/api_service.dart';

class ProfileRepository{
  final ApiService _apiService = ApiService();
  Future<ProfileModel> profileRepo() async {
    try {
      final response = await _apiService.get("user/getprofile");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = json.decode(response.body);
        return ProfileModel.fromJson(userData);
      } else {
        throw Exception("Failed to fetch user profile. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching profile: $e");
    }
  }
  Future<bool> updateProfileRepo(Map<String,dynamic> updateData) async{
    try{
      final response = await _apiService.put("user/update", updateData);
      if(response.statusCode == 201 || response.statusCode == 200 || response.statusCode == 204){
        print("Backend profile update successful.");
        return true;
      }else{
        print("Backend profile update failed. Status: ${response.statusCode}, Body: ${response.body}");
        return false;
      }
    }catch (e) {
      print("Error updating profile: $e");
      return false;
    }
  }
}