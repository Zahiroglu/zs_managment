// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_configrations.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelConfigrationsAdapter extends TypeAdapter<ModelConfigrations> {
  @override
  final int typeId = 33;

  @override
  ModelConfigrations read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelConfigrations(
      companyId: fields[1] as int,
      confCode: fields[2] as String,
      confVal: fields[3] as String,
      roleId: fields[4] as int,
      abbreaviation1: fields[5] as String,
      abbreaviation2: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ModelConfigrations obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.companyId)
      ..writeByte(2)
      ..write(obj.confCode)
      ..writeByte(3)
      ..write(obj.confVal)
      ..writeByte(4)
      ..write(obj.roleId)
      ..writeByte(5)
      ..write(obj.abbreaviation1)
      ..writeByte(6)
      ..write(obj.abbreaviation2);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelConfigrationsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
