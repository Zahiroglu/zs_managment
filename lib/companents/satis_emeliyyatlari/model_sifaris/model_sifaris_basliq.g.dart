// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_sifaris_basliq.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelSifarisBasliqAdapter extends TypeAdapter<ModelSifarisBasliq> {
  @override
  final int typeId = 41;

  @override
  ModelSifarisBasliq read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelSifarisBasliq(
      id: fields[0] as int?,
      gps: fields[1] as String?,
      expdiscount: fields[2] as String?,
      projectAdi: fields[3] as String?,
      projectCode: fields[4] as String?,
      sendClick: fields[5] as String?,
      sendType: fields[6] as String?,
      musteriCodu: fields[7] as String?,
      musteriAdi: fields[8] as String?,
      odemeTipi: fields[9] as String?,
      anbarCodu: fields[10] as String?,
      anbarAdi: fields[11] as String?,
      catdirilmaTarixi: fields[12] as String?,
      layiheCodu: fields[13] as String?,
      layiheAdi: fields[14] as String?,
      mesMerCodu: fields[15] as String?,
      mesMerAdi: fields[16] as String?,
      etrafli: fields[17] as String?,
      aracem: fields[18] as String?,
      endirim: fields[19] as String?,
      edv: fields[20] as String?,
      cem: fields[21] as String?,
      faktKod: fields[22] as String?,
      fDates: fields[23] as String?,
      fStatus: fields[24] as String?,
      faktCreateDate: fields[25] as String?,
      faktPortfel: fields[26] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ModelSifarisBasliq obj) {
    writer
      ..writeByte(27)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.gps)
      ..writeByte(2)
      ..write(obj.expdiscount)
      ..writeByte(3)
      ..write(obj.projectAdi)
      ..writeByte(4)
      ..write(obj.projectCode)
      ..writeByte(5)
      ..write(obj.sendClick)
      ..writeByte(6)
      ..write(obj.sendType)
      ..writeByte(7)
      ..write(obj.musteriCodu)
      ..writeByte(8)
      ..write(obj.musteriAdi)
      ..writeByte(9)
      ..write(obj.odemeTipi)
      ..writeByte(10)
      ..write(obj.anbarCodu)
      ..writeByte(11)
      ..write(obj.anbarAdi)
      ..writeByte(12)
      ..write(obj.catdirilmaTarixi)
      ..writeByte(13)
      ..write(obj.layiheCodu)
      ..writeByte(14)
      ..write(obj.layiheAdi)
      ..writeByte(15)
      ..write(obj.mesMerCodu)
      ..writeByte(16)
      ..write(obj.mesMerAdi)
      ..writeByte(17)
      ..write(obj.etrafli)
      ..writeByte(18)
      ..write(obj.aracem)
      ..writeByte(19)
      ..write(obj.endirim)
      ..writeByte(20)
      ..write(obj.edv)
      ..writeByte(21)
      ..write(obj.cem)
      ..writeByte(22)
      ..write(obj.faktKod)
      ..writeByte(23)
      ..write(obj.fDates)
      ..writeByte(24)
      ..write(obj.fStatus)
      ..writeByte(25)
      ..write(obj.faktCreateDate)
      ..writeByte(26)
      ..write(obj.faktPortfel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelSifarisBasliqAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
