
import 'package:hive/hive.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:zs_managment/global_models/custom_enummaptype.dart';
import 'package:zs_managment/global_models/utils.dart';
part 'model_maptypeapp.g.dart';

@HiveType(typeId: 11)
class ModelMapApp extends HiveObject{
  @HiveField(0)
  String? name;
  @HiveField(1)
  CustomMapType? mapType;
  @HiveField(2)
  String? icon;

  ModelMapApp({required  this.mapType, required this.name, required this.icon});

  @override
  String toString() {
    return 'ModelMapApp{name: $name, mapType: $mapType, kode: $icon}';
  }
  static ModelMapApp? fromJson(json) {
    final CustomMapType? mapType = Utils.enumFromString(CustomMapType.values, json['mapType']);
    if (mapType != null) {
      return ModelMapApp(
        name: json['mapName'],
        mapType: mapType,
        icon: ('packages/map_launcher/assets/icons/${json['mapType']}.svg').toString(),
      );
    } else {
      return null;
    }
  }



}
