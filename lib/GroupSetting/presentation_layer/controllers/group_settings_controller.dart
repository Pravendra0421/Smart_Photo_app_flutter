import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../data_layer/repository/groupSettingRepository.dart';
import '../../data_layer/models/group_member_model.dart';
import '../../data_layer/models/member_group_info_model.dart';
class GroupSettingController extends GetxController{
  final GroupSettingRepository repository =GroupSettingRepository();
  final AuthService authService = Get.find<AuthService>();
  final String groupId;
  GroupSettingController({required this.groupId});
  var isLoading =true.obs;
  var allMember =<GroupMemberModel>[].obs;
  var groupInfo = Rx<MemberGroupInfoModel?>(null);
  var currentUserRole = 'MEMBER'.obs;
  @override
  void onInit(){
    super.onInit();
    fetchGroupMember();
  }
  void fetchGroupMember() async{
    try{
      isLoading.value = true;
      final List<GroupMemberModel>membersList = await repository.getGroupMembers(groupId);
      if(membersList.isNotEmpty){
        groupInfo.value = membersList[0].group;
        final String currentUserDbId = authService.currentUser.value!.id;
        if(groupInfo.value!.ownerId == currentUserDbId){
          currentUserRole.value ='OWNER';
        }else{
          var myMembership = membersList.firstWhere((m)=>m.user.id == currentUserDbId,orElse: ()=>membersList[0]);
          currentUserRole.value = myMembership.role;
        }
        allMember.assignAll(membersList);
      }
    }catch(e){
    Get.snackbar("Error", "Could not load group members: ${e.toString()}");
    }finally{
    isLoading.value = false;
    }
  }
}