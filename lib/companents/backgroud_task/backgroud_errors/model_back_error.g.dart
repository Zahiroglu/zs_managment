// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_back_error.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelBackErrorsAdapter extends TypeAdapter<ModelBackErrors> {
  @override
  final int typeId = 31;

  @override
  ModelBackErrors read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelBackErrors(
      userCode: fields[0] as String?,
      userPosition: fields[1] as int?,
      userFullName: fields[2] as String?,
      errCode: fields[3] as String?,
      errName: fields[4] as String?,
      errDate: fields[5] as String?,
      deviceId: fields[6] as String?,
      locationLatitude: fields[7] as String?,
      locationLongitude: fields[8] as String?,
      sendingStatus: fields[9] as String?,
      description: fields[10] as String?,
      userId: fields[11] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ModelBackErrors obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.userCode)
      ..writeByte(1)
      ..write(obj.userPosition)
      ..writeByte(2)
      ..write(obj.userFullName)
      ..writeByte(3)
      ..write(obj.errCode)
      ..writeByte(4)
      ..write(obj.errName)
      ..writeByte(5)
      ..write(obj.errDate)
      ..writeByte(6)
      ..write(obj.deviceId)
      ..writeByte(7)
      ..write(obj.locationLatitude)
      ..writeByte(8)
      ..write(obj.locationLongitude)
      ..writeByte(9)
      ..write(obj.sendingStatus)
      ..writeByte(10)
      ..write(obj.description)
      ..writeByte(11)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelBackErrorsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
