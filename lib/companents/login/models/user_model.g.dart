// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 5;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as int?,
      code: fields[1] as String?,
      name: fields[2] as String?,
      surname: fields[3] as String?,
      fatherName: fields[4] as String?,
      birthdate: fields[5] as String?,
      gender: fields[6] as int?,
      phone: fields[7] as String?,
      email: fields[8] as String?,
      deviceId: fields[9] as String?,
      moduleId: fields[10] as int?,
      moduleName: fields[11] as String?,
      roleId: fields[12] as int?,
      roleName: fields[13] as String?,
      regionCode: fields[14] as String?,
      regionName: fields[15] as String?,
      deviceLogin: fields[16] as bool?,
      usernameLogin: fields[17] as bool?,
      username: fields[18] as String?,
      companyId: fields[19] as int?,
      companyName: fields[20] as String?,
      modelModules: (fields[21] as List?)?.cast<ModelModule>(),
      connections: (fields[22] as List?)?.cast<ModelUserConnection>(),
      permissions: (fields[23] as List?)?.cast<ModelUserPermissions>(),
      draweItems: (fields[24] as List?)?.cast<ModelUserPermissions>(),
      expDate: fields[25] as int?,
      addDateStr: fields[26] as String?,
      requestNumber: fields[27] as String?,
      lastOnlineDate: fields[28] as String?,
      active: fields[29] as bool?,
      regionLongitude: fields[31] as double?,
      regionLatitude: fields[30] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(32)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.surname)
      ..writeByte(4)
      ..write(obj.fatherName)
      ..writeByte(5)
      ..write(obj.birthdate)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.phone)
      ..writeByte(8)
      ..write(obj.email)
      ..writeByte(9)
      ..write(obj.deviceId)
      ..writeByte(10)
      ..write(obj.moduleId)
      ..writeByte(11)
      ..write(obj.moduleName)
      ..writeByte(12)
      ..write(obj.roleId)
      ..writeByte(13)
      ..write(obj.roleName)
      ..writeByte(14)
      ..write(obj.regionCode)
      ..writeByte(15)
      ..write(obj.regionName)
      ..writeByte(16)
      ..write(obj.deviceLogin)
      ..writeByte(17)
      ..write(obj.usernameLogin)
      ..writeByte(18)
      ..write(obj.username)
      ..writeByte(19)
      ..write(obj.companyId)
      ..writeByte(20)
      ..write(obj.companyName)
      ..writeByte(21)
      ..write(obj.modelModules)
      ..writeByte(22)
      ..write(obj.connections)
      ..writeByte(23)
      ..write(obj.permissions)
      ..writeByte(24)
      ..write(obj.draweItems)
      ..writeByte(25)
      ..write(obj.expDate)
      ..writeByte(26)
      ..write(obj.addDateStr)
      ..writeByte(27)
      ..write(obj.requestNumber)
      ..writeByte(28)
      ..write(obj.lastOnlineDate)
      ..writeByte(29)
      ..write(obj.active)
      ..writeByte(30)
      ..write(obj.regionLatitude)
      ..writeByte(31)
      ..write(obj.regionLongitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
