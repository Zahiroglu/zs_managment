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
      configId: fields[1] as int,
      confCode: fields[2] as String,
      confVal: fields[3] as String,
      data1: fields[4] as String,
      data2: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ModelConfigrations obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.configId)
      ..writeByte(2)
      ..write(obj.confCode)
      ..writeByte(3)
      ..write(obj.confVal)
      ..writeByte(4)
      ..write(obj.data1)
      ..writeByte(5)
      ..write(obj.data2);
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
