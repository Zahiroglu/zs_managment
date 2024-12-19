

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/models/model_company.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';

class SettingPanelController extends GetxController{
  Rx<UserModel> modelModule = UserModel().obs;
  LocalUserServices localUserServices=LocalUserServices();


   @override
  void onInit() {
     getCurrentLoggedUserFromLocale();
    // TODO: implement onInit
    super.onInit();
  }

   Future<void> getCurrentLoggedUserFromLocale([UserModel? model]) async{
     if(model!=null){
       modelModule.value=model;
     }else {
       await localUserServices.init();
       modelModule.value = localUserServices
           .getLoggedUser()
           .userModel!;
     }


     print("getCurrentLoggedUserFromLocale :"+modelModule.value.toString());
     update();
   }


}