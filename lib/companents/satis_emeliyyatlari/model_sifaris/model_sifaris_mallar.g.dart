// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_sifaris_mallar.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelSifarisMallarAdapter extends TypeAdapter<ModelSifarisMallar> {
  @override
  final int typeId = 40;

  @override
  ModelSifarisMallar read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelSifarisMallar(
      id: fields[0] as int?,
      stockId: fields[1] as String?,
      kodu: fields[2] as String?,
      adi: fields[3] as String?,
      qiymet: fields[4] as double?,
      miqdar: fields[5] as int?,
      qaliq: fields[6] as int?,
      confirm: fields[7] as String?,
      faiz: fields[8] as double?,
      endirim: fields[9] as double?,
      cem: fields[10] as double?,
      faId: fields[11] as int?,
      yekunMiqd: fields[12] as double?,
      vahid: fields[13] as String?,
      bolen: fields[14] as String?,
      kompaniyaStatus: fields[15] as String?,
      anbarNo: fields[16] as String?,
      goodDiscount: fields[17] as double?,
      aracem: fields[18] as double?,
      faizIskonto1: fields[19] as double?,
      cemIskonto1: fields[20] as double?,
      faizIskonto2: fields[21] as double?,
      cemIskonto2: fields[22] as double?,
      faizIskonto3: fields[23] as double?,
      cemIskonto3: fields[24] as double?,
      faizIskonto4: fields[25] as double?,
      cemIskonto4: fields[26] as double?,
      note: fields[27] as String?,
      rangeFilter: fields[28] as double?,
      rangePercent: fields[29] as double?,
      rangeSum: fields[30] as double?,
      scanNum: fields[31] as String?,
      stokKg: fields[32] as double?,
      edv: fields[33] as double?,
      vatValue: fields[34] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ModelSifarisMallar obj) {
    writer
      ..writeByte(35)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.stockId)
      ..writeByte(2)
      ..write(obj.kodu)
      ..writeByte(3)
      ..write(obj.adi)
      ..writeByte(4)
      ..write(obj.qiymet)
      ..writeByte(5)
      ..write(obj.miqdar)
      ..writeByte(6)
      ..write(obj.qaliq)
      ..writeByte(7)
      ..write(obj.confirm)
      ..writeByte(8)
      ..write(obj.faiz)
      ..writeByte(9)
      ..write(obj.endirim)
      ..writeByte(10)
      ..write(obj.cem)
      ..writeByte(11)
      ..write(obj.faId)
      ..writeByte(12)
      ..write(obj.yekunMiqd)
      ..writeByte(13)
      ..write(obj.vahid)
      ..writeByte(14)
      ..write(obj.bolen)
      ..writeByte(15)
      ..write(obj.kompaniyaStatus)
      ..writeByte(16)
      ..write(obj.anbarNo)
      ..writeByte(17)
      ..write(obj.goodDiscount)
      ..writeByte(18)
      ..write(obj.aracem)
      ..writeByte(19)
      ..write(obj.faizIskonto1)
      ..writeByte(20)
      ..write(obj.cemIskonto1)
      ..writeByte(21)
      ..write(obj.faizIskonto2)
      ..writeByte(22)
      ..write(obj.cemIskonto2)
      ..writeByte(23)
      ..write(obj.faizIskonto3)
      ..writeByte(24)
      ..write(obj.cemIskonto3)
      ..writeByte(25)
      ..write(obj.faizIskonto4)
      ..writeByte(26)
      ..write(obj.cemIskonto4)
      ..writeByte(27)
      ..write(obj.note)
      ..writeByte(28)
      ..write(obj.rangeFilter)
      ..writeByte(29)
      ..write(obj.rangePercent)
      ..writeByte(30)
      ..write(obj.rangeSum)
      ..writeByte(31)
      ..write(obj.scanNum)
      ..writeByte(32)
      ..write(obj.stokKg)
      ..writeByte(33)
      ..write(obj.edv)
      ..writeByte(34)
      ..write(obj.vatValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelSifarisMallarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
