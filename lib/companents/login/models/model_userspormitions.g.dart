// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_userspormitions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelUserPermissionsAdapter extends TypeAdapter<ModelUserPermissions> {
  @override
  final int typeId = 7;

  @override
  ModelUserPermissions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelUserPermissions(
      id: fields[0] as int?,
      code: fields[1] as String?,
      name: fields[2] as String?,
      val: fields[3] as int?,
      valName: fields[4] as String?,
      screen: fields[5] as bool?,
      icon: fields[6] as int?,
      selectIcon: fields[7] as int?,
      category: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ModelUserPermissions obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.val)
      ..writeByte(4)
      ..write(obj.valName)
      ..writeByte(5)
      ..write(obj.screen)
      ..writeByte(6)
      ..write(obj.icon)
      ..writeByte(7)
      ..write(obj.selectIcon)
      ..writeByte(8)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelUserPermissionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
