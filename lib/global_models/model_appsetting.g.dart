// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_appsetting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelAppSettingAdapter extends TypeAdapter<ModelAppSetting> {
  @override
  final int typeId = 10;

  @override
  ModelAppSetting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelAppSetting(
      mapsetting: fields[0] as ModelMapApp?,
      girisCixisType: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ModelAppSetting obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.mapsetting)
      ..writeByte(1)
      ..write(obj.girisCixisType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelAppSettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
