import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zs_managment/language/lang_constants.dart';
import 'package:zs_managment/language/localization_controller.dart';
import 'package:zs_managment/language/model_language.dart';

  Future<Map<String, Map<String, String>>> init() async {
    final sharedPreference = await SharedPreferences.getInstance();
    Get.lazyPut(() => sharedPreference);

    Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));

    // Retrieving localized data
    Map<String, Map<String, String>> languages = {};
    for (LanguageModel languageModel in LangConstants.languages) {
      String jsonStringValues = await rootBundle
          .loadString('language/${languageModel.languageCode}.json');
      Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
      Map<String, String> jsona = {};

      mappedJson.forEach((key, value) {
        jsona[key] = value.toString();
      });
      languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
          jsona;
    }

    return languages;
  }
