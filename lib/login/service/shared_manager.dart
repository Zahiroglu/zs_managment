import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zs_managment/login/models/logged_usermodel.dart';
import 'package:zs_managment/login/models/model_company.dart';
import 'package:zs_managment/login/models/model_token.dart';
import 'package:zs_managment/login/models/model_userconnnection.dart';
import 'package:zs_managment/login/models/model_userspormitions.dart';
import 'package:zs_managment/login/models/user_model.dart';

class SharedManager {
  SharedPreferences? preferences;


  SharedManager();

  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
    print("Share init edildi!");
  }


  void saveIfFirstTimeOpen()async {
    await preferences?.setBool("isOppened",true);
    }

  Future<bool?> checkIsFistTimeOpen()async{
    _checkPrefences();
    if(preferences!.getBool("isOppened")==null){
      return false;
    }else{
      return preferences?.getBool("isOppened");
    }}

  Future<void>  saveChangedThema(bool val)async{
    await preferences?.setBool("themaisDak",val);

  }

  Future<bool?> getSavedThema()async{
    _checkPrefences();
    if(preferences!.getString("keyUser")==null){
      return false;
    }else{
      return preferences?.getBool("themaisDak");
  }}

  void _checkPrefences() {
    if (preferences == null) throw "SharedPreferance tapilmadi";
  }

  void cleareAllInfo()async{
   await preferences?.clear();

  }

  Future<void> saveUser(String keyUser,LoggedUserModel model) async {
    print("Melumat yazilir");
    await preferences?.setString(keyUser,jsonEncode(model));
    getLoggedUser();
  }

  Future<LoggedUserModel> getLoggedUser()async{
    _checkPrefences();
    if(preferences!.getString("keyUser")==null){
     return LoggedUserModel();
   }else{
     LoggedUserModel loggedModel=LoggedUserModel.fromJson(jsonDecode(preferences!.getString("keyUser")!));
     // UserModel userModel=loggedModel.userModel!;
     // TokenModel tokenModel=loggedModel.tokenModel!;
     // CompanyModel companyModel=loggedModel.companyModel!;
     // // print("userModel Shaered:$userModel");
     // // print("tokenModel Shaered:$tokenModel");
     // // print("companyModel Shaered:$companyModel");
     return loggedModel;
   }

  }

  Future<TokenModel> getTokens()async{
    _checkPrefences();
    if(preferences!.getString("keyUser")==null){
      return TokenModel();
    }else{
      LoggedUserModel loggedModel=LoggedUserModel.fromJson(jsonDecode(preferences!.getString("keyUser")!));
      TokenModel tokenModel=loggedModel.tokenModel!;
      return tokenModel;
  }}

  Future<List<ModelUserConnection>> getUsersConnections()async{
    List<ModelUserConnection> listConnections=[];
    if(preferences!.getString("keyUser")==null){
      return [];
    }else{
      LoggedUserModel loggedModel=LoggedUserModel.fromJson(jsonDecode(preferences!.getString("keyUser")!));
      UserModel userModel=loggedModel.userModel!;
      listConnections =userModel.connections!;
      return listConnections;
    }
  }

  Future<List<ModelUserPermissions>> getUsersPermissions()async{
    List<ModelUserPermissions> listPermissions=[];
    if(preferences!.getString("keyUser")==null){
      return [];
    }else{
      LoggedUserModel loggedModel=LoggedUserModel.fromJson(jsonDecode(preferences!.getString("keyUser")!));
      UserModel userModel=loggedModel.userModel!;
      listPermissions =userModel.permissions!;
      return listPermissions;
    }
  }

}