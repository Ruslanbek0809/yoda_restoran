// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_vol_cus.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveVolCusAdapter extends TypeAdapter<HiveVolCus> {
  @override
  final int typeId = 2;

  @override
  HiveVolCus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveVolCus(
      id: fields[0] as int?,
      name: fields[1] as String?,
      price: fields[2] as num?,
      groupId: fields[3] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveVolCus obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.groupId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveVolCusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
