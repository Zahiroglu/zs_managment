import 'package:zs_managment/companents/login/models/model_userspormitions.dart';

class UsersPermitionsHelper {

  bool hasUserPermition(String perCode,List<ModelUserPermissions> listPermitions)  {
    listPermitions.forEach((element){
      print(element.code.toString()+" : "+element.val.toString());

    });
    print(perCode+" : "+listPermitions.any((element)=>element.code==perCode).toString());
   return  listPermitions.any((element)=>element.code==perCode);
  }

}