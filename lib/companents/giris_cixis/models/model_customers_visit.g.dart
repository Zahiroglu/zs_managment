// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_customers_visit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelCustuomerVisitAdapter extends TypeAdapter<ModelCustuomerVisit> {
  @override
  final int typeId = 13;

  @override
  ModelCustuomerVisit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelCustuomerVisit(
      userCode: fields[0] as String?,
      userPosition: fields[1] as String?,
      customerCode: fields[2] as String?,
      userFullName: fields[3] as String?,
      customerName: fields[4] as String?,
      customerLatitude: fields[5] as String?,
      customerLongitude: fields[6] as String?,
      inDate: fields[7] as DateTime?,
      inLatitude: fields[8] as String?,
      inLongitude: fields[9] as String?,
      inDistance: fields[10] as String?,
      inNote: fields[11] as String?,
      outDate: fields[12] as DateTime?,
      outLatitude: fields[13] as String?,
      outLongitude: fields[14] as String?,
      outDistance: fields[15] as String?,
      outNote: fields[16] as String?,
      workTimeInCustomer: fields[17] as String?,
      isRutDay: fields[18] as bool?,
      inDt: fields[19] as DateTime?,
      gonderilme: fields[20] as String?,
      operationType: fields[21] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ModelCustuomerVisit obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.userCode)
      ..writeByte(1)
      ..write(obj.userPosition)
      ..writeByte(2)
      ..write(obj.customerCode)
      ..writeByte(3)
      ..write(obj.userFullName)
      ..writeByte(4)
      ..write(obj.customerName)
      ..writeByte(5)
      ..write(obj.customerLatitude)
      ..writeByte(6)
      ..write(obj.customerLongitude)
      ..writeByte(7)
      ..write(obj.inDate)
      ..writeByte(8)
      ..write(obj.inLatitude)
      ..writeByte(9)
      ..write(obj.inLongitude)
      ..writeByte(10)
      ..write(obj.inDistance)
      ..writeByte(11)
      ..write(obj.inNote)
      ..writeByte(12)
      ..write(obj.outDate)
      ..writeByte(13)
      ..write(obj.outLatitude)
      ..writeByte(14)
      ..write(obj.outLongitude)
      ..writeByte(15)
      ..write(obj.outDistance)
      ..writeByte(16)
      ..write(obj.outNote)
      ..writeByte(17)
      ..write(obj.workTimeInCustomer)
      ..writeByte(18)
      ..write(obj.isRutDay)
      ..writeByte(19)
      ..write(obj.inDt)
      ..writeByte(20)
      ..write(obj.gonderilme)
      ..writeByte(21)
      ..write(obj.operationType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelCustuomerVisitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
