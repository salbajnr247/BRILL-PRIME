// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveUserModelAdapter extends TypeAdapter<HiveUserModel> {
  @override
  final int typeId = 1;

  @override
  HiveUserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveUserModel(
      userId: fields[0] as dynamic,
      fullName: fields[1] as String?,
      email: fields[2] as String?,
      token: fields[5] as String?,
      phoneNumber: fields[3] as String?,
      userName: fields[4] as String?,
      address: fields[6] as String?,
      vcn: fields[7] as String?,
      role: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveUserModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.userName)
      ..writeByte(5)
      ..write(obj.token)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.vcn)
      ..writeByte(8)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveUserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
