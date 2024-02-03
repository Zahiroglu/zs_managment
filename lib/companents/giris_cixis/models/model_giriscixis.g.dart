// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_giriscixis.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelGirisCixisAdapter extends TypeAdapter<ModelGirisCixis> {
  @override
  final int typeId = 13;

  @override
  ModelGirisCixis read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelGirisCixis(
      ckod: fields[0] as String?,
      cariad: fields[1] as String?,
      girisvaxt: fields[2] as String?,
      cixisvaxt: fields[3] as String?,
      girisgps: fields[4] as String?,
      cixisgps: fields[5] as String?,
      temsilcikodu: fields[6] as String?,
      qeyd: fields[7] as String?,
      girismesafe: fields[8] as String?,
      cixismesafe: fields[9] as String?,
      rutgunu: fields[10] as String?,
      vezifeId: fields[11] as String?,
      tarix: fields[12] as String?,
      temsilciadi: fields[13] as String?,
      gonderilme: fields[14] as String?,
      marketgpsUzunluq: fields[15] as String?,
      marketgpsEynilik: fields[16] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ModelGirisCixis obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.ckod)
      ..writeByte(1)
      ..write(obj.cariad)
      ..writeByte(2)
      ..write(obj.girisvaxt)
      ..writeByte(3)
      ..write(obj.cixisvaxt)
      ..writeByte(4)
      ..write(obj.girisgps)
      ..writeByte(5)
      ..write(obj.cixisgps)
      ..writeByte(6)
      ..write(obj.temsilcikodu)
      ..writeByte(7)
      ..write(obj.qeyd)
      ..writeByte(8)
      ..write(obj.girismesafe)
      ..writeByte(9)
      ..write(obj.cixismesafe)
      ..writeByte(10)
      ..write(obj.rutgunu)
      ..writeByte(11)
      ..write(obj.vezifeId)
      ..writeByte(12)
      ..write(obj.tarix)
      ..writeByte(13)
      ..write(obj.temsilciadi)
      ..writeByte(14)
      ..write(obj.gonderilme)
      ..writeByte(15)
      ..write(obj.marketgpsUzunluq)
      ..writeByte(16)
      ..write(obj.marketgpsEynilik);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelGirisCixisAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
