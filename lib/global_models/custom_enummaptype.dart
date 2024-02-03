import 'package:hive/hive.dart';
part 'custom_enummaptype.g.dart';

@HiveType(typeId: 12)
enum CustomMapType {
  @HiveField(0)
  apple,
  @HiveField(1)
  google,
  @HiveField(2)
  googleGo,
  @HiveField(3)
  amap,
  @HiveField(4)
  baidu,
  @HiveField(5)
  waze,
  @HiveField(6)
  yandexMaps,
  @HiveField(7)
  yandexNavi,
  @HiveField(8)
  citymapper,
  @HiveField(9)
  mapswithme,
  @HiveField(10)
  osmand,
  @HiveField(11)
  osmandplus,
  @HiveField(12)
  doubleGis,
  @HiveField(13)
  tencent,
  @HiveField(14)
  here,
  @HiveField(15)
  petal,
  @HiveField(16)
  tomtomgo,
}