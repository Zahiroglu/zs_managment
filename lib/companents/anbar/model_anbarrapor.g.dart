// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_anbarrapor.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelAnbarRaporAdapter extends TypeAdapter<ModelAnbarRapor> {
  @override
  final int typeId = 22;

  @override
  ModelAnbarRapor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelAnbarRapor(
      stokkod: fields[0] as String?,
      stokadi: fields[1] as String?,
      anaqrup: fields[2] as String?,
      qaliq: fields[3] as String?,
      vahidbir: fields[4] as String?,
      satisqiymeti: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ModelAnbarRapor obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.stokkod)
      ..writeByte(1)
      ..write(obj.stokadi)
      ..writeByte(2)
      ..write(obj.anaqrup)
      ..writeByte(3)
      ..write(obj.qaliq)
      ..writeByte(4)
      ..write(obj.vahidbir)
      ..writeByte(5)
      ..write(obj.satisqiymeti);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelAnbarRaporAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
