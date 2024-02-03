// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_carikassa.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelCariKassaAdapter extends TypeAdapter<ModelCariKassa> {
  @override
  final int typeId = 25;

  @override
  ModelCariKassa read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelCariKassa(
      cariKod: fields[0] as String?,
      kassaMebleg: fields[1] as double?,
      gonderildi: fields[2] as bool?,
      tarix: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ModelCariKassa obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.cariKod)
      ..writeByte(1)
      ..write(obj.kassaMebleg)
      ..writeByte(2)
      ..write(obj.gonderildi)
      ..writeByte(3)
      ..write(obj.tarix);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelCariKassaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
