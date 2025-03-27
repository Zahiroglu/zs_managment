// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_numbering.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NumberingAdapter extends TypeAdapter<Numbering> {
  @override
  final int typeId = 42;

  @override
  Numbering read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Numbering(
      id: fields[0] as int,
      number: fields[1] as int,
      type: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Numbering obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.number)
      ..writeByte(2)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NumberingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
