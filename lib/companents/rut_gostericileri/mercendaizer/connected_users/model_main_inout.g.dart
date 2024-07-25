// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_main_inout.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelMainInOutAdapter extends TypeAdapter<ModelMainInOut> {
  @override
  final int typeId = 34;

  @override
  ModelMainInOut read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelMainInOut(
      userCode: fields[1] as String,
      userPosition: fields[2] as String,
      userFullName: fields[3] as String,
      modelInOutDays: (fields[4] as List).cast<ModelInOutDay>(),
    );
  }

  @override
  void write(BinaryWriter writer, ModelMainInOut obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.userCode)
      ..writeByte(2)
      ..write(obj.userPosition)
      ..writeByte(3)
      ..write(obj.userFullName)
      ..writeByte(4)
      ..write(obj.modelInOutDays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelMainInOutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModelInOutDayAdapter extends TypeAdapter<ModelInOutDay> {
  @override
  final int typeId = 35;

  @override
  ModelInOutDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelInOutDay(
      day: fields[1] as String,
      visitedCount: fields[2] as int,
      firstEnterDate: fields[3] as String,
      lastExitDate: fields[4] as String,
      workTimeInCustomer: fields[5] as String,
      workTimeInArea: fields[6] as String,
      modelInOut: (fields[7] as List).cast<ModelInOut>(),
    );
  }

  @override
  void write(BinaryWriter writer, ModelInOutDay obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.day)
      ..writeByte(2)
      ..write(obj.visitedCount)
      ..writeByte(3)
      ..write(obj.firstEnterDate)
      ..writeByte(4)
      ..write(obj.lastExitDate)
      ..writeByte(5)
      ..write(obj.workTimeInCustomer)
      ..writeByte(6)
      ..write(obj.workTimeInArea)
      ..writeByte(7)
      ..write(obj.modelInOut);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelInOutDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModelInOutAdapter extends TypeAdapter<ModelInOut> {
  @override
  final int typeId = 36;

  @override
  ModelInOut read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelInOut(
      userCode: fields[1] as dynamic,
      userPosition: fields[2] as dynamic,
      customerCode: fields[3] as dynamic,
      userFullName: fields[4] as dynamic,
      customerName: fields[5] as dynamic,
      customerLatitude: fields[6] as dynamic,
      customerLongitude: fields[7] as dynamic,
      inDate: fields[8] as dynamic,
      inLatitude: fields[9] as dynamic,
      inLongitude: fields[10] as dynamic,
      inDistance: fields[11] as dynamic,
      inNote: fields[12] as dynamic,
      outDate: fields[13] as dynamic,
      outLatitude: fields[14] as dynamic,
      outLongitude: fields[15] as dynamic,
      outDistance: fields[16] as dynamic,
      outNote: fields[17] as dynamic,
      workTimeInCustomer: fields[18] as dynamic,
      isRutDay: fields[19] as dynamic,
      inDt: fields[20] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, ModelInOut obj) {
    writer
      ..writeByte(20)
      ..writeByte(1)
      ..write(obj.userCode)
      ..writeByte(2)
      ..write(obj.userPosition)
      ..writeByte(3)
      ..write(obj.customerCode)
      ..writeByte(4)
      ..write(obj.userFullName)
      ..writeByte(5)
      ..write(obj.customerName)
      ..writeByte(6)
      ..write(obj.customerLatitude)
      ..writeByte(7)
      ..write(obj.customerLongitude)
      ..writeByte(8)
      ..write(obj.inDate)
      ..writeByte(9)
      ..write(obj.inLatitude)
      ..writeByte(10)
      ..write(obj.inLongitude)
      ..writeByte(11)
      ..write(obj.inDistance)
      ..writeByte(12)
      ..write(obj.inNote)
      ..writeByte(13)
      ..write(obj.outDate)
      ..writeByte(14)
      ..write(obj.outLatitude)
      ..writeByte(15)
      ..write(obj.outLongitude)
      ..writeByte(16)
      ..write(obj.outDistance)
      ..writeByte(17)
      ..write(obj.outNote)
      ..writeByte(18)
      ..write(obj.workTimeInCustomer)
      ..writeByte(19)
      ..write(obj.isRutDay)
      ..writeByte(20)
      ..write(obj.inDt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelInOutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
