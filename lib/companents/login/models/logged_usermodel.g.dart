// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logged_usermodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoggedUserModelAdapter extends TypeAdapter<LoggedUserModel> {
  @override
  final int typeId = 2;

  @override
  LoggedUserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoggedUserModel(
      tokenModel: fields[0] as TokenModel?,
      userModel: fields[1] as UserModel?,
      companyModel: fields[2] as CompanyModel?,
      companyConfigModel: (fields[5] as List?)?.cast<ModelConfigrations>(),
      isLogged: fields[3] as bool?,
      baseUrl: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LoggedUserModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.tokenModel)
      ..writeByte(1)
      ..write(obj.userModel)
      ..writeByte(2)
      ..write(obj.companyModel)
      ..writeByte(5)
      ..write(obj.companyConfigModel)
      ..writeByte(3)
      ..write(obj.isLogged)
      ..writeByte(4)
      ..write(obj.baseUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoggedUserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
