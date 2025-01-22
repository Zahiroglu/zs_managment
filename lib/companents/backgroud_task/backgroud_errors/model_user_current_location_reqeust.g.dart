// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_user_current_location_reqeust.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelUsercCurrentLocationReqeustAdapter
    extends TypeAdapter<ModelUsercCurrentLocationReqeust> {
  @override
  final int typeId = 32;

  @override
  ModelUsercCurrentLocationReqeust read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelUsercCurrentLocationReqeust(
      userCode: fields[0] as String?,
      userPosition: fields[1] as String?,
      userFullName: fields[2] as String?,
      latitude: fields[3] as double?,
      longitude: fields[4] as double?,
      locationDate: fields[5] as String?,
      speed: fields[6] as double?,
      isOnline: fields[7] as bool?,
      pastInputCustomerCode: fields[8] as String?,
      pastInputCustomerName: fields[9] as String?,
      inputCustomerDistance: fields[10] as int?,
      batteryLevel: fields[11] as double?,
      sendingStatus: fields[12] as String?,
      locationHeading: fields[13] as double?,
      locAccuracy: fields[14] as double?,
      isMoving: fields[15] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, ModelUsercCurrentLocationReqeust obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.userCode)
      ..writeByte(1)
      ..write(obj.userPosition)
      ..writeByte(2)
      ..write(obj.userFullName)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude)
      ..writeByte(5)
      ..write(obj.locationDate)
      ..writeByte(6)
      ..write(obj.speed)
      ..writeByte(7)
      ..write(obj.isOnline)
      ..writeByte(8)
      ..write(obj.pastInputCustomerCode)
      ..writeByte(9)
      ..write(obj.pastInputCustomerName)
      ..writeByte(10)
      ..write(obj.inputCustomerDistance)
      ..writeByte(11)
      ..write(obj.batteryLevel)
      ..writeByte(12)
      ..write(obj.sendingStatus)
      ..writeByte(13)
      ..write(obj.locationHeading)
      ..writeByte(14)
      ..write(obj.locAccuracy)
      ..writeByte(15)
      ..write(obj.isMoving);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelUsercCurrentLocationReqeustAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
