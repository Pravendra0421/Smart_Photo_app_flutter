import 'package:get/get.dart';
import '../../Home/data_layer/models/user_model.dart';
import '../../Home/data_layer/repository/auth_repository.dart';

class AuthService extends GetxService {
  final AuthRepository _repository = AuthRepository();

  var currentUser = Rx<UserModel?>(null);

  Future<void> fetchAndSetCurrentUser() async {
    try {
      final userProfile = await _repository.fetchCurrentUser();
      currentUser.value = userProfile;

    } catch (e) {
      print("Error in AuthService: $e");
    }
  }

  void logout() {
    currentUser.value = null;
    // ... Firebase logout logic
  }
}