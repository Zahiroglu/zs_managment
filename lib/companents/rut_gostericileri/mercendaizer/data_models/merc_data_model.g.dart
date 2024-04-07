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
      user: fields[1] as UserMerc?,
      mercCustomersDatail: (fields[2] as List?)?.cast<MercCustomersDatail>(),
    );
  }

  @override
  void write(BinaryWriter writer, MercDataModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.user)
      ..writeByte(2)
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
      sellingDatas: (fields[19] as List?)?.cast<SellingData>(),
      totalPlan: fields[20] as double?,
      totalSelling: fields[21] as double?,
      totalRefund: fields[22] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, MercCustomersDatail obj) {
    writer
      ..writeByte(22)
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
      ..write(obj.sellingDatas)
      ..writeByte(20)
      ..write(obj.totalPlan)
      ..writeByte(21)
      ..write(obj.totalSelling)
      ..writeByte(22)
      ..write(obj.totalRefund);
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

class SellingDataAdapter extends TypeAdapter<SellingData> {
  @override
  final int typeId = 29;

  @override
  SellingData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SellingData(
      forwarderCode: fields[1] as String,
      plans: fields[2] as double,
      selling: fields[3] as double,
      remainder: fields[4] as double,
      refund: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SellingData obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.forwarderCode)
      ..writeByte(2)
      ..write(obj.plans)
      ..writeByte(3)
      ..write(obj.selling)
      ..writeByte(4)
      ..write(obj.remainder)
      ..writeByte(5)
      ..write(obj.refund);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SellingDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserMercAdapter extends TypeAdapter<UserMerc> {
  @override
  final int typeId = 30;

  @override
  UserMerc read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserMerc(
      code: fields[1] as String,
      name: fields[2] as String,
      totalPlan: fields[3] as double,
      totalSelling: fields[4] as double,
      totalRefund: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, UserMerc obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.totalPlan)
      ..writeByte(4)
      ..write(obj.totalSelling)
      ..writeByte(5)
      ..write(obj.totalRefund);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserMercAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
