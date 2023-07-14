import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zs_managment/language/lang_constants.dart';
import 'package:zs_managment/language/model_language.dart';

class LocalizationController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;

  LocalizationController({required this.sharedPreferences}) {
    loadCurrentLanguage();
    loadCurrentThema();
  }

  Locale _locale = Locale(LangConstants.languages[0].languageCode,
      LangConstants.languages[0].countryCode);
  bool _isLtr = true;
  List<LanguageModel> _languages = [];
  bool isDark = false;

  Locale get locale => _locale;

  bool get isLtr => _isLtr;

  List<LanguageModel> get languages => _languages;

  void setLanguage(Locale locale) {
    Get.updateLocale(locale);
    _locale = locale;
    if (_locale.languageCode == 'bn') {
      _isLtr = false;
    } else {
      _isLtr = true;
    }
    saveLanguage(_locale);
    update();
  }

  void loadCurrentLanguage() async {
    _locale = Locale(
        sharedPreferences.getString(LangConstants.LANGUAGE_CODE) ??
            LangConstants.languages[0].languageCode,
        sharedPreferences.getString(LangConstants.COUNTRY_CODE) ??
            LangConstants.languages[0].countryCode);
    _isLtr = _locale.languageCode != 'bn';
    for (int index = 0; index < LangConstants.languages.length; index++) {
      if (LangConstants.languages[index].languageCode == _locale.languageCode) {
        _selectedIndex = index;
        break;
      }
    }
    _languages = [];
    _languages.addAll(LangConstants.languages);
    update();
  }

  void saveLanguage(Locale locale) async {
    sharedPreferences.setString(
        LangConstants.LANGUAGE_CODE, locale.languageCode);
    sharedPreferences.setString(
        LangConstants.COUNTRY_CODE, locale.countryCode!);
  }

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectIndex(int index) {
    _selectedIndex = index;
    update();
  }

  void searchLanguage(String query) {
    if (query.isEmpty) {
      _languages = [];
      _languages = LangConstants.languages;
    } else {
      _selectedIndex = -1;
      _languages = [];
      LangConstants.languages.forEach((language) async {
        if (language.languageName.toLowerCase().contains(query.toLowerCase())) {
          _languages.add(language);
        }
      });
    }
    update();
  }

  LanguageModel getlastLanguage() {
    LanguageModel model = _languages.first;
    String contrykod = _locale.languageCode;
    _languages.forEach((element) {
      if (element.languageCode == contrykod) {
        model = element;
      }
    });
    return model;
  }

  ////Thema/////
  toggleTheme(bool isdark) {
    Get.changeTheme(isdark ? ThemeData.dark() : ThemeData.light());
    isDark = isdark;
    saveThema(isdark);
    update();
  }

  void saveThema(bool isDark) async {
    sharedPreferences.setBool("themaisDak", isDark);
    update();
  }

  Future<void> loadCurrentThema() async {
    bool? isdark = sharedPreferences.getBool("themaisDak");
    if (isdark == null) {
    } else {
      Get.changeTheme(isdark? ThemeData.dark() : ThemeData.light());
      isDark = isdark;
    }
    update();
  }
}
