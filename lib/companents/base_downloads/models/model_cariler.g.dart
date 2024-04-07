// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_cariler.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelCarilerAdapter extends TypeAdapter<ModelCariler> {
  @override
  final int typeId = 21;

  @override
  ModelCariler read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelCariler(
      code: fields[1] as String?,
      name: fields[2] as String?,
      fullAddress: fields[3] as String?,
      ownerPerson: fields[4] as String?,
      phone: fields[5] as String?,
      postalCode: fields[6] as String?,
      area: fields[7] as String?,
      category: fields[8] as String?,
      regionalDirectorCode: fields[9] as String?,
      salesDirectorCode: fields[10] as String?,
      latitude: fields[11] as double?,
      longitude: fields[12] as double?,
      district: fields[13] as String?,
      tin: fields[14] as String?,
      mainCustomer: fields[15] as String?,
      debt: fields[16] as double?,
      action: fields[17] as bool?,
      days: (fields[18] as List?)?.cast<Day>(),
      forwarderCode: fields[19] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ModelCariler obj) {
    writer
      ..writeByte(19)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.fullAddress)
      ..writeByte(4)
      ..write(obj.ownerPerson)
      ..writeByte(5)
      ..write(obj.phone)
      ..writeByte(6)
      ..write(obj.postalCode)
      ..writeByte(7)
      ..write(obj.area)
      ..writeByte(8)
      ..write(obj.category)
      ..writeByte(9)
      ..write(obj.regionalDirectorCode)
      ..writeByte(10)
      ..write(obj.salesDirectorCode)
      ..writeByte(11)
      ..write(obj.latitude)
      ..writeByte(12)
      ..write(obj.longitude)
      ..writeByte(13)
      ..write(obj.district)
      ..writeByte(14)
      ..write(obj.tin)
      ..writeByte(15)
      ..write(obj.mainCustomer)
      ..writeByte(16)
      ..write(obj.debt)
      ..writeByte(17)
      ..write(obj.action)
      ..writeByte(18)
      ..write(obj.days)
      ..writeByte(19)
      ..write(obj.forwarderCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelCarilerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DayAdapter extends TypeAdapter<Day> {
  @override
  final int typeId = 26;

  @override
  Day read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Day(
      day: fields[1] as int,
      orderNumber: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Day obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.day)
      ..writeByte(2)
      ..write(obj.orderNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
