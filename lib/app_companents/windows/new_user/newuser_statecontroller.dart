import 'package:flutter/cupertino.dart';
import 'package:zs_managment/app_companents/model/model_modules.dart';
import 'package:zs_managment/app_companents/model/model_vezifeler.dart';
import 'package:zs_managment/app_companents/windows/admin_usercontrol/controller/useraccesController.dart';
import 'package:zs_managment/login/models/model_company.dart';
import 'package:zs_managment/login/models/model_regions.dart';
import 'package:zs_managment/login/models/model_useracces.dart';
import 'package:zs_managment/login/models/user_model.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';


class NewUsersStateController extends ChangeNotifier{
  bool isLoading=false;
  List<String> listStepper = [
    'ilkinsecim'.tr,
    'genelinfo'.tr,
    "Icazeler",
    "Baglantilar",
  ];
  //List<String> listInfoUsers = UserModel().getListUserInfoDetail();
  List<ModelModules> listSobeler = ModelModules().getAktivModules();
  List<ModelRegions> listRegionlar = ModelRegions().listRegions();
  List<ModelVezifeler> listVezifeler = [];
  ModelModules? selectedSobe;
  ModelVezifeler? selectedVezife;
  ModelRegions? selectedRegion;
  ModelRegions? get getselectedRegion=>selectedRegion;
  bool regionSecilmelidir = false;
  bool ilkinMelumatlarSecildi = false;
  bool regionSecildi = false;
  bool sobeSecildi = false;
  bool vezifeSecildi = false;
  bool canUseMobile = false;
  bool canUseWindows = false;
  bool istifadeIcazesiItenildi=false;




//////////////////////////list access
  List<GroupUserAcces> listAccess = [];
  UserAccessController accessController = UserAccessController();


  void changeLoading(){
    isLoading=!isLoading;
    notifyListeners();
  }

  ///////////////Ilkin Melumatlar secimi////

  ModelModules?  getSelectedSobe(){
    return selectedSobe;
  }
  void changeSelectedRegion(ModelRegions model){
    regionSecildi=true;
    selectedRegion=model;
    notifyListeners();
  }
  void changeSelectedSobe(ModelModules model){
    sobeSecildi=true;
    vezifeSecildi=false;
    selectedSobe=model;
    notifyListeners();
    fullVezifelerListi(model);
  }
  void changeSelectedVezife(ModelVezifeler model){
    vezifeSecildi=true;
    selectedVezife=model;
    listAccess= accessController.allUsersAcces();
    notifyListeners();
  }
  void fullVezifelerListi(ModelModules val) {
    selectedVezife = null;
    listVezifeler = val.listVezifeler!;
    notifyListeners();
  }
  void checkIfRegionMustSelect(){
    if(listRegionlar.length==1){
      selectedRegion=listRegionlar.first;
      regionSecilmelidir=false;
      regionSecildi=true;
    }else{
      regionSecilmelidir=true;
      regionSecildi=false;
    }
    notifyListeners();
  }

  ///////////////Iczeeler////
 void changeCnUseMobile(bool val){
    canUseMobile=val;
    if(canUseWindows){
      istifadeIcazesiItenildi=true;
    }else{
      istifadeIcazesiItenildi=false;
    }
    notifyListeners();
 }
 void changeCnUseWindows(bool val){
  canUseWindows=val;
  if(canUseMobile){
    istifadeIcazesiItenildi=true;
  }else{
    istifadeIcazesiItenildi=false;
  }
    notifyListeners();
 }

////////////////tab selector////////////////
void updateAccesList(int groupIndex,int accesIndex,AccesType accesType){
    listAccess.elementAt(groupIndex).listAccess!.elementAt(accesIndex).accesType=accesType;
    notifyListeners();
}




}