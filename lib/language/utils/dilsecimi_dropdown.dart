import 'package:flutter/material.dart';
import 'package:zs_managment/companents/login/services/api_services/users_controller_mobile.dart';
import 'package:zs_managment/companents/local_bazalar/local_users_services.dart';
import 'package:zs_managment/companents/main_screen/controller/drawer_menu_controller.dart';
import 'package:zs_managment/language/lang_constants.dart';
import 'package:zs_managment/language/localization_controller.dart';
import 'package:zs_managment/language/model_language.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
import 'package:get/get.dart';

class WidgetDilSecimi extends StatelessWidget {
  WidgetDilSecimi({Key? key,required this.callBack, required this.localizationController,this.isLoginScreen}) : super(key: key);
  LocalizationController localizationController;
  Function callBack;
  bool? isLoginScreen = false;
  final apiControllerMobile = Get.lazyPut(() => UserApiControllerMobile()); // will inject that dependecy, and wait until it's used then it will call onInit() method, then onReady() method
  LocalUserServices localUserServices=LocalUserServices();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 30,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Get.isDarkMode ? Colors.white : Colors.black)),
        child: DropdownButton(
            alignment: Alignment.center,
            hint: Row(
              children: [
                Image.asset(localizationController.getlastLanguage().imageUrl,
                    width: 15, height: 15),
                const SizedBox(
                  width: 5,
                ),
                CustomText(
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    labeltext: localizationController.getlastLanguage().countryCode)
              ],
            ),
            underline: const SizedBox(),
            elevation: 10,
            icon: const Icon(Icons.expand_more_outlined),
            items: LangConstants.languages.map<DropdownMenuItem<LanguageModel>>((lang) =>
                DropdownMenuItem(value: lang, child: Row(
                        children: [
                          Image.asset(lang.imageUrl, width: 20, height: 20),
                          const SizedBox(
                            width: 5,
                          ),
                          CustomText(labeltext: lang.countryCode)
                        ],
                      )),).toList(),
            onChanged: (lang) async {
              if (localizationController.getlastLanguage() != lang!) {
                bool isSucces = false;
                if(isLoginScreen??false){
                  int index = LangConstants.languages.indexOf(lang);
                  localizationController.setLanguage(Locale(
                    LangConstants.languages[index].languageCode,
                    LangConstants.languages[index].countryCode,));
                  localizationController.setSelectIndex(index);
                }else {
                    localUserServices.init();
                    isSucces = await UserApiControllerMobile().loginWithMobileDviceIdForDrawerItems(lang.languageCode);
                  if (isSucces) {
                    int index = LangConstants.languages.indexOf(lang);
                    localizationController.setLanguage(Locale(LangConstants.languages[index].languageCode, LangConstants.languages[index].countryCode,));
                    localizationController.setSelectIndex(index);
                    callBack.call();

                  }
                }}
            }),
      ),
    );
  }
}
