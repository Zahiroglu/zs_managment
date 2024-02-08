import 'package:hive/hive.dart';
import 'package:zs_managment/companents/login/models/logged_usermodel.dart';

class LocalUserServices {
  late Box loggedUserBox = Hive.box("LoggedUsers");
  late Box appFirstTimeOpen=Hive.box("firstTimeOpen");

  Future<void> init() async {
    loggedUserBox = await Hive.openBox("LoggedUsers");
    appFirstTimeOpen = await Hive.openBox("firstTimeOpen");
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
    await appFirstTimeOpen.add(value);
  }


  Future<bool> getIfAppOpenFistOrNot() async {
    bool value = await appFirstTimeOpen.get("LoggedUsers")??false;
    return value;
  }

  clearALLdata() {
    late Box loggedUserBox = Hive.box("LoggedUsers");
    late Box loggedLanguage = Hive.box("myLanguage");
    loggedLanguage.clear();
    loggedUserBox.clear();
  }
}
