import 'dart:convert';
import '../../../core/services/api_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  Future<UserModel> fetchCurrentUser() async {
    try {
      final response = await _apiService.get("user/getprofile");
      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        return UserModel.fromJson(userData);
      } else {
        throw Exception("Failed to fetch user profile. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching profile: $e");
    }
  }
}