import  'dart:convert';
import 'package:http/http.dart' as http;
import '../models/onboardingModel.dart';
class OnboardingRepository{
  final String _apiUrl = "http://192.168.29.217:3000/api/onboarding";
  Future<List <OnboardingModel>> getOnboardingData() async{
    try{
      final response = await http.get(Uri.parse('$_apiUrl/get'));
      if(response.statusCode == 201){
        List<dynamic> jsonData = json.decode(response.body);
        List<OnboardingModel> pages = jsonData.map((item)=>OnboardingModel.fromJson(item)).toList();
        pages.sort((a,b)=>a.order.compareTo(b.order));
        return pages;
      }else{
        throw Exception('Failed to load onboarding data');
      }
    }catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}