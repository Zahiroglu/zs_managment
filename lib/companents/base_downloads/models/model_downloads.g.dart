// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_downloads.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelDownloadsAdapter extends TypeAdapter<ModelDownloads> {
  @override
  final int typeId = 23;

  @override
  ModelDownloads read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelDownloads(
      code: fields[0] as String?,
      name: fields[1] as String?,
      lastDownDay: fields[2] as String?,
      musteDonwload: fields[3] as bool?,
      info: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ModelDownloads obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.lastDownDay)
      ..writeByte(3)
      ..write(obj.musteDonwload)
      ..writeByte(4)
      ..write(obj.info);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelDownloadsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
