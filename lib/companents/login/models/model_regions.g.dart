// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_regions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelRegionsAdapter extends TypeAdapter<ModelRegions> {
  @override
  final int typeId = 9;

  @override
  ModelRegions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelRegions(
      id: fields[0] as int?,
      code: fields[1] as String?,
      name: fields[2] as String?,
      level: fields[3] as int?,
      parentId: fields[4] as int?,
      locationLatitude: fields[5] as String?,
      locationLongitude: fields[6] as String?,
      address: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ModelRegions obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.level)
      ..writeByte(4)
      ..write(obj.parentId)
      ..writeByte(5)
      ..write(obj.locationLatitude)
      ..writeByte(6)
      ..write(obj.locationLongitude)
      ..writeByte(7)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelRegionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
