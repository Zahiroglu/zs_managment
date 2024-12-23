import 'package:hive/hive.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';

class LocalUserServices {
  late Box loggedUserBox;
  late Box appFirstTimeOpen;
  late Box canGetBaseUrl;

  Future<void> init() async {
    loggedUserBox = await Hive.openBox("LoggedUsers");
    appFirstTimeOpen = await Hive.openBox("firstTimeOpen");
    canGetBaseUrl = await Hive.openBox("canGetBaseUrl");
  }


  Future<void> addUserToLocalDB(LoggedUserModel loggedUserModel) async {
    await loggedUserBox.clear();
    await loggedUserBox.add(loggedUserModel);
  }

  LoggedUserModel getLoggedUser() => loggedUserBox.values.firstOrNull ?? LoggedUserModel();

  Future<String> getLoggedToken() async {
    LoggedUserModel loggedUserModel =  getLoggedUser();
    return loggedUserModel.tokenModel!.accessToken!;
  }

  Future<String> getRefreshToken() async {
    LoggedUserModel loggedUserModel =  getLoggedUser();
    return loggedUserModel.tokenModel!.refreshToken!;
  }

  Future<void> addValueForAppFistTimeOpen(bool value) async {
    await appFirstTimeOpen.clear();
    await appFirstTimeOpen.put("firstTimeOpen",value);
  }


  Future<bool> getIfAppOpenFistOrNot() async {
    bool value = await appFirstTimeOpen.get("firstTimeOpen")??false;
    return value;
  }


  clearALLdata() {
    late Box loggedUserBox = Hive.box("LoggedUsers");
    late Box loggedLanguage = Hive.box("myLanguage");
   // late Box canGetBaseUrl = Hive.box("canGetBaseUrl");
    loggedLanguage.clear();
    loggedUserBox.clear();
    canGetBaseUrl.clear();
  }
  clearBaseUrl() {
    late Box canGetBaseUrl = Hive.box("canGetBaseUrl");
    canGetBaseUrl.clear();
  }
  clearLoggedUserInfo() {
    late Box loggedUserBox = Hive.box("LoggedUsers");
    loggedUserBox.clear();
  }
}
