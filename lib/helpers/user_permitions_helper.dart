import 'package:zs_managment/companents/login/models/logged_usermodel.dart';
import 'package:zs_managment/companents/login/models/model_configrations.dart';
import 'package:zs_managment/companents/login/models/model_userspormitions.dart';

class UserPermitionsHelper {
  static String canEnterOtherMerchCustomers="canEnterOtherMerchCustomers";


  // bool hasUserPermition(String perCode,List<ModelUserPermissions> listPermitions)  {
  //  return  listPermitions.any((element)=>element.code==perCode);
  // }

  bool canEditMercCustomersRutDay (List<ModelUserPermissions> listPermitions){
    bool hasAccess=false;
    if(listPermitions.isNotEmpty) {
      hasAccess= listPermitions.any((e) => e.code=="canEditMercCustomersRutDay");
    }
    return hasAccess;
  }
  bool canEditMercCustomersPlan (List<ModelUserPermissions> listPermitions){
    bool hasAccess=false;
    if(listPermitions.isNotEmpty) {
      hasAccess= listPermitions.any((e) => e.code=="canEditMercCustomersPlan");
    }
    return hasAccess;
  }
  bool canEditMercCustomers (List<ModelUserPermissions> listPermitions){
    bool hasAccess=false;
    if(listPermitions.isNotEmpty) {
      hasAccess= listPermitions.any((e) => e.code=="canEditMercCustomers");
    }
    return hasAccess;
  }
  bool canSellProducts(List<ModelUserPermissions> listPermitions) {
    bool hasAccess=false;
    if(listPermitions.isNotEmpty) {
      hasAccess= listPermitions.any((e) => e.code=="canCell");
    }
    return hasAccess;
  }




  //Configrations
  List<String> getUserWorkTime(List<ModelConfigrations> confirm) {
    String girisvaxti = confirm.where((c) => c.configId == 1).first.data1.toString();
    String cixisvaxt = confirm.where((c) => c.configId == 1).first.data2.toString();

    return [girisvaxti, cixisvaxt];
  }

  int getEnterDistance(List<ModelConfigrations> confirm) {
    if(confirm.where((c) => c.configId == 7).isNotEmpty){
    int girisvaxti = int.parse(confirm.where((c) => c.configId == 7).first.data1.toString());

    return girisvaxti;}else{
      return 0;
    }
  }

  int daySalary(List<ModelConfigrations> confirm) {
    if(confirm.where((c) => c.configId == 3).isNotEmpty){
    int daysalary = int.parse(confirm.where((c) => c.configId == 3).first.data1.toString());
    return daysalary;
    }else{
      return 0;
    }
  }

  bool getOnlyByGirisCixis(List<ModelConfigrations> confirm) {
    if(confirm.where((c) => c.configId == 4).isNotEmpty) {
      bool onlyGirisCixis = bool.parse(confirm
          .where((c) => c.configId == 4)
          .first
          .data1
          .toString());
      return onlyGirisCixis;
    }else{
      return false;
    }}

  bool getOnlyByRutDay(List<ModelConfigrations> confirm) {
    if(confirm.where((c) => c.configId == 5).isNotEmpty) {
      bool getOnlyByRutDay = bool.parse(confirm
          .where((c) => c.configId == 5)
          .first
          .data1
          .toString());
      return getOnlyByRutDay;
    }

    return false;
  }

  bool onlyByRutOrderNumber(List<ModelConfigrations> confirm) {
    if(confirm.where((c) => c.configId == 6).isNotEmpty) {
      bool onlyByRutOrderNumber = bool.parse(confirm
          .where((c) => c.configId == 6)
          .first
          .data1
          .toString());
      return onlyByRutOrderNumber;
    }
    return false;
  }

  bool mercHasMotivationSystem(List<ModelConfigrations> confirm) {
    if(confirm.where((c) => c.configId == 8).isNotEmpty){
    bool onlyByRutOrderNumber = bool.parse(confirm.where((c) => c.configId == 8).first.data1.toString());
    return onlyByRutOrderNumber;}
    return false;
  }

  bool liveTrack(List<ModelConfigrations> confirm) {
    if(confirm.where((c) => c.configId == 2).isNotEmpty){
    bool liveTrack = bool.parse(confirm.where((c) => c.configId == 2).first.data1.toString());
    return liveTrack;}else{
      return false;
    }
  }


}