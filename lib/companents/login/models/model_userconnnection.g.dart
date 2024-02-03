// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_userconnnection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelUserConnectionAdapter extends TypeAdapter<ModelUserConnection> {
  @override
  final int typeId = 6;

  @override
  ModelUserConnection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelUserConnection(
      roleId: fields[0] as int?,
      roleName: fields[1] as String?,
      code: fields[2] as String?,
      fullName: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ModelUserConnection obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.roleId)
      ..writeByte(1)
      ..write(obj.roleName)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.fullName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelUserConnectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
