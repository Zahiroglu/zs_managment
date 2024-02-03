// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_carihereket.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelCariHereketAdapter extends TypeAdapter<ModelCariHereket> {
  @override
  final int typeId = 24;

  @override
  ModelCariHereket read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelCariHereket(
      cariKod: fields[0] as String?,
      stockKod: fields[1] as String?,
      temKod: fields[2] as String?,
      qiymet: fields[3] as double?,
      miqdar: fields[4] as int?,
      netSatis: fields[5] as double?,
      endirimMebleg: fields[6] as double?,
      gonderildi: fields[7] as bool?,
      tarix: fields[8] as String?,
      anaQrup: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ModelCariHereket obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.cariKod)
      ..writeByte(1)
      ..write(obj.stockKod)
      ..writeByte(2)
      ..write(obj.temKod)
      ..writeByte(3)
      ..write(obj.qiymet)
      ..writeByte(4)
      ..write(obj.miqdar)
      ..writeByte(5)
      ..write(obj.netSatis)
      ..writeByte(6)
      ..write(obj.endirimMebleg)
      ..writeByte(7)
      ..write(obj.gonderildi)
      ..writeByte(8)
      ..write(obj.tarix)
      ..writeByte(9)
      ..write(obj.anaQrup);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelCariHereketAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
