import 'dart:convert';
import 'package:http/http.dart' as http;
class SmartAppRepository {
  final String _baseurl ="http://192.168.29.217:3000/api/user";
  Future<bool> loginOrRegisterUser({required String uid, required String phoneNumber , required String token}) async {
    try{
      final response = await http.post(
        Uri.parse('$_baseurl/create'),
        headers:{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'uid':uid,'phoneNumber':phoneNumber})
      );
      if(response.statusCode == 201){
        return true;
      }else {
        print("Backend Error: ${response.body}");
        return false;
      }
    }catch (e) {
      print("HTTP Error: $e");
      return false;
    //   hello
    }
  }
}