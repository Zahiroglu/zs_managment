// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_maptypeapp.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelMapAppAdapter extends TypeAdapter<ModelMapApp> {
  @override
  final int typeId = 11;

  @override
  ModelMapApp read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelMapApp(
      mapType: fields[1] as CustomMapType?,
      name: fields[0] as String?,
      icon: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ModelMapApp obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.mapType)
      ..writeByte(2)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelMapAppAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
