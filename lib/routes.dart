import 'package:get/get.dart';
import 'onboarding/presentation_layer/bindings/onboarding_binding.dart'; // We will create this next
import 'onboarding/presentation_layer/screens/login_screen.dart'; // The UI screen
// import 'onboarding/presentation_layer/screens/home_screen.dart'; // A placeholder home screen
import 'onboarding/presentation_layer/screens/onboarding_screen.dart';
import 'onboarding/presentation_layer/screens/phoneLogin_screen.dart';
import 'Home/presentation_layer/screens/home_screen.dart';
import 'Home/presentation_layer/screens/create_group_screen.dart';
import 'Home/presentation_layer/screens/GroupDetailScreen.dart';
import 'Home/presentation_layer/screens/shareDetailScreen.dart';
import 'Home/presentation_layer/screens/join_group_screen.dart';
import 'Profile/presentation_layer/screens/profile_screen.dart';
import 'main_screen.dart';
class AppRoutes {
  static const ONBOARDING ='/onboarding';
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const PHONELOGIN ='/phonelogin';
  static const CREATEGROUP = '/create-group';
  static const GROUPDETAIL ='/group-detail';
  static const SHAREDETAIL ='/share-detail';
  static const JOINGROUP ='/join-group';
  static const PROFILEDETAIL ='/profile-detail';
  static const MAINSCREEN ='/main-screen';
}

class AppPages {
  static final routes = [
    GetPage(
        name: AppRoutes.MAINSCREEN,
        page:()=>MainScreen(),
    ),
    GetPage(
        name: AppRoutes.ONBOARDING,
        page:()=>OnboardingScreen(),
        binding: SmartAppBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginScreen(),
      binding: SmartAppBinding(), // Link the binding to the route
    ),
    GetPage(name: AppRoutes.PHONELOGIN, page:()=> Login(),binding: SmartAppBinding()),
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeScreen(),
      // You can add a HomeBinding if needed
    ),
    GetPage(
        name: AppRoutes.CREATEGROUP,
        page: ()=>CreateGroupScreen(),
    ),
    GetPage(
        name: AppRoutes.GROUPDETAIL,
        page: ()=>GroupDetailScreen(),
    ),
    GetPage(
        name: AppRoutes.SHAREDETAIL,
        page: ()=>shareDetailScreen(),
    ),
    GetPage(
        name: AppRoutes.JOINGROUP,
        page: ()=>joinGroupScreen(),
    ),
    GetPage(
        name: AppRoutes.PROFILEDETAIL,
        page: ()=>ProfileScreen(),
    ),
  ];
}