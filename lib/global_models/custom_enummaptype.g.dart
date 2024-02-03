// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_enummaptype.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomMapTypeAdapter extends TypeAdapter<CustomMapType> {
  @override
  final int typeId = 12;

  @override
  CustomMapType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CustomMapType.apple;
      case 1:
        return CustomMapType.google;
      case 2:
        return CustomMapType.googleGo;
      case 3:
        return CustomMapType.amap;
      case 4:
        return CustomMapType.baidu;
      case 5:
        return CustomMapType.waze;
      case 6:
        return CustomMapType.yandexMaps;
      case 7:
        return CustomMapType.yandexNavi;
      case 8:
        return CustomMapType.citymapper;
      case 9:
        return CustomMapType.mapswithme;
      case 10:
        return CustomMapType.osmand;
      case 11:
        return CustomMapType.osmandplus;
      case 12:
        return CustomMapType.doubleGis;
      case 13:
        return CustomMapType.tencent;
      case 14:
        return CustomMapType.here;
      case 15:
        return CustomMapType.petal;
      case 16:
        return CustomMapType.tomtomgo;
      default:
        return CustomMapType.apple;
    }
  }

  @override
  void write(BinaryWriter writer, CustomMapType obj) {
    switch (obj) {
      case CustomMapType.apple:
        writer.writeByte(0);
        break;
      case CustomMapType.google:
        writer.writeByte(1);
        break;
      case CustomMapType.googleGo:
        writer.writeByte(2);
        break;
      case CustomMapType.amap:
        writer.writeByte(3);
        break;
      case CustomMapType.baidu:
        writer.writeByte(4);
        break;
      case CustomMapType.waze:
        writer.writeByte(5);
        break;
      case CustomMapType.yandexMaps:
        writer.writeByte(6);
        break;
      case CustomMapType.yandexNavi:
        writer.writeByte(7);
        break;
      case CustomMapType.citymapper:
        writer.writeByte(8);
        break;
      case CustomMapType.mapswithme:
        writer.writeByte(9);
        break;
      case CustomMapType.osmand:
        writer.writeByte(10);
        break;
      case CustomMapType.osmandplus:
        writer.writeByte(11);
        break;
      case CustomMapType.doubleGis:
        writer.writeByte(12);
        break;
      case CustomMapType.tencent:
        writer.writeByte(13);
        break;
      case CustomMapType.here:
        writer.writeByte(14);
        break;
      case CustomMapType.petal:
        writer.writeByte(15);
        break;
      case CustomMapType.tomtomgo:
        writer.writeByte(16);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomMapTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
