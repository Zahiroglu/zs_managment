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
      forwarderCode: fields[3] as String?,
      fullAddress: fields[4] as String?,
      ownerPerson: fields[5] as String?,
      phone: fields[6] as String?,
      postalCode: fields[7] as String?,
      area: fields[8] as String?,
      category: fields[9] as String?,
      regionalDirectorCode: fields[10] as String?,
      salesDirectorCode: fields[11] as String?,
      latitude: fields[12] as String?,
      longitude: fields[13] as String?,
      district: fields[14] as String?,
      tin: fields[15] as String?,
      mainCustomer: fields[16] as String?,
      debt: fields[17] as double?,
      day1: fields[18] as int?,
      day2: fields[19] as int?,
      day3: fields[20] as int?,
      day4: fields[21] as int?,
      day5: fields[22] as int?,
      day6: fields[23] as int?,
      day7: fields[24] as int?,
      action: fields[25] as bool?,
      orderNumber: fields[26] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ModelCariler obj) {
    writer
      ..writeByte(26)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.forwarderCode)
      ..writeByte(4)
      ..write(obj.fullAddress)
      ..writeByte(5)
      ..write(obj.ownerPerson)
      ..writeByte(6)
      ..write(obj.phone)
      ..writeByte(7)
      ..write(obj.postalCode)
      ..writeByte(8)
      ..write(obj.area)
      ..writeByte(9)
      ..write(obj.category)
      ..writeByte(10)
      ..write(obj.regionalDirectorCode)
      ..writeByte(11)
      ..write(obj.salesDirectorCode)
      ..writeByte(12)
      ..write(obj.latitude)
      ..writeByte(13)
      ..write(obj.longitude)
      ..writeByte(14)
      ..write(obj.district)
      ..writeByte(15)
      ..write(obj.tin)
      ..writeByte(16)
      ..write(obj.mainCustomer)
      ..writeByte(17)
      ..write(obj.debt)
      ..writeByte(18)
      ..write(obj.day1)
      ..writeByte(19)
      ..write(obj.day2)
      ..writeByte(20)
      ..write(obj.day3)
      ..writeByte(21)
      ..write(obj.day4)
      ..writeByte(22)
      ..write(obj.day5)
      ..writeByte(23)
      ..write(obj.day6)
      ..writeByte(24)
      ..write(obj.day7)
      ..writeByte(25)
      ..write(obj.action)
      ..writeByte(26)
      ..write(obj.orderNumber);
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
