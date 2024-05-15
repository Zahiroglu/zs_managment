import 'package:hive/hive.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';

class LocalUserServices {
  late Box loggedUserBox = Hive.box("LoggedUsers");
  late Box appFirstTimeOpen=Hive.box("firstTimeOpen");
  late Box canGetBaseUrl=Hive.box("canGetBaseUrl");

  Future<void> init() async {
    loggedUserBox = await Hive.openBox("LoggedUsers");
    appFirstTimeOpen = await Hive.openBox("firstTimeOpen");
    canGetBaseUrl = await Hive.openBox("canGetBaseUrl");
  }

  Future<void> addUserToLocalDB(LoggedUserModel loggedUserModel) async {
    await loggedUserBox.clear();
    await loggedUserBox.add(loggedUserModel);
  }

  LoggedUserModel getLoggedUser() =>
      loggedUserBox.values.firstOrNull ?? LoggedUserModel();

  Future<String> getLoggedToken() async {
    LoggedUserModel loggedUserModel = await loggedUserBox.get("LoggedUsers");
    return loggedUserModel.tokenModel!.accessToken!;
  }

  Future<String> getRefreshToken() async {
    LoggedUserModel loggedUserModel = await loggedUserBox.get("LoggedUsers");
    return loggedUserModel.tokenModel!.refreshToken!;
  }

  Future<void> addValueForAppFistTimeOpen(bool value) async {
    await appFirstTimeOpen.clear();
    await appFirstTimeOpen.put("firstTimeOpen",value);
  }
  Future<void> addCanGetBaseUrl(String value) async {
    await canGetBaseUrl.clear();
    await canGetBaseUrl.put("canGetBaseUrl",value);
  }


  Future<bool> getIfAppOpenFistOrNot() async {
    bool value = await appFirstTimeOpen.get("LoggedUsers")??false;
    return value;
  }

  Future<String> getCanGetBaseUrl() async {
    String value = await canGetBaseUrl.get("canGetBaseUrl")??"Bos";
    return value;
  }

  clearALLdata() {
    late Box loggedUserBox = Hive.box("LoggedUsers");
    late Box loggedLanguage = Hive.box("myLanguage");
    late Box canGetBaseUrl = Hive.box("canGetBaseUrl");
    loggedLanguage.clear();
    loggedUserBox.clear();
    canGetBaseUrl.clear();
  }
  clearLoggedUserInfo() {
    late Box loggedUserBox = Hive.box("LoggedUsers");
    loggedUserBox.clear();
  }
}
