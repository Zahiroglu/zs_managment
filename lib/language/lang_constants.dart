
import 'package:zs_managment/language/model_language.dart';

class LangConstants {
  static const String appName = 'ZS-MANAGMENT';
  static const String logoName = 'XX';
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  
  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: "images/az.png", languageName: 'Azerbaijan', countryCode: 'AZ', languageCode: 'az'),
    LanguageModel(imageUrl: "images/gb.png", languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: "images/ru.png", languageName: 'Russian', countryCode: 'RU', languageCode: 'ru'),
    LanguageModel(imageUrl: "images/tr.png", languageName: 'Turkish', countryCode: 'TR', languageCode: 'tr'),
  ];
}