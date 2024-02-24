// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merc_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MercDataModelAdapter extends TypeAdapter<MercDataModel> {
  @override
  final int typeId = 27;

  @override
  MercDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MercDataModel(
      totalPlans: fields[1] as double?,
      totalSelling: fields[2] as double?,
      totalRefund: fields[3] as double?,
      code: fields[4] as String?,
      name: fields[5] as String?,
      mercCustomersDatail: (fields[6] as List?)?.cast<MercCustomersDatail>(),
    );
  }

  @override
  void write(BinaryWriter writer, MercDataModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.totalPlans)
      ..writeByte(2)
      ..write(obj.totalSelling)
      ..writeByte(3)
      ..write(obj.totalRefund)
      ..writeByte(4)
      ..write(obj.code)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.mercCustomersDatail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MercDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MercCustomersDatailAdapter extends TypeAdapter<MercCustomersDatail> {
  @override
  final int typeId = 28;

  @override
  MercCustomersDatail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MercCustomersDatail(
      code: fields[1] as String?,
      name: fields[2] as String?,
      plans: fields[3] as double?,
      selling: fields[4] as double?,
      refund: fields[5] as double?,
      fullAddress: fields[6] as String?,
      forwarderCode: fields[14] as String?,
      area: fields[7] as String?,
      category: fields[8] as String?,
      latitude: fields[9] as String?,
      longitude: fields[10] as String?,
      district: fields[11] as String?,
      action: fields[12] as bool?,
      days: (fields[13] as List?)?.cast<Day>(),
    );
  }

  @override
  void write(BinaryWriter writer, MercCustomersDatail obj) {
    writer
      ..writeByte(14)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.plans)
      ..writeByte(4)
      ..write(obj.selling)
      ..writeByte(5)
      ..write(obj.refund)
      ..writeByte(6)
      ..write(obj.fullAddress)
      ..writeByte(7)
      ..write(obj.area)
      ..writeByte(8)
      ..write(obj.category)
      ..writeByte(9)
      ..write(obj.latitude)
      ..writeByte(10)
      ..write(obj.longitude)
      ..writeByte(11)
      ..write(obj.district)
      ..writeByte(12)
      ..write(obj.action)
      ..writeByte(13)
      ..write(obj.days)
      ..writeByte(14)
      ..write(obj.forwarderCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MercCustomersDatailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
