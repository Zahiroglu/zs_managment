import 'package:hive/hive.dart';
part 'model_language.g.dart';

@HiveType(typeId: 1)
class LanguageModel {
  @HiveField(0)
  String imageUrl;
  @HiveField(1)
  String languageName;
  @HiveField(2)
  String languageCode;
  @HiveField(3)
  String countryCode;

  LanguageModel({
    required this.imageUrl,
    required this.languageName,
    required this.countryCode,
    required this.languageCode});

  @override
  String toString() {
    return 'LanguageModel{imageUrl: $imageUrl, languageName: $languageName, languageCode: $languageCode, countryCode: $countryCode}';
  }
}