import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/models/model_userspormitions.dart';

class UserPermitionsHelper {
  static String canEnterOtherMerchCustomers="canEnterOtherMerchCustomers";


  bool hasUserPermition(String perCode,List<ModelUserPermissions> listPermitions)  {
   return  listPermitions.any((element)=>element.code==perCode);
  }
  bool hasCompanyConfig(String perCode,LoggedUserModel model)  {
   // return model.companyConfigModel!.where((e)=>e.confCode==perCode).first;
    //return  listPermitions.any((element)=>element.code==perCode);
    return false;
  }

}