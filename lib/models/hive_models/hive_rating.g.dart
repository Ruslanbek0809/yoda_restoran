// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_rating.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveRatingAdapter extends TypeAdapter<HiveRating> {
  @override
  final int typeId = 5;

  @override
  HiveRating read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveRating(
      id: fields[0] as String?,
      resId: fields[1] as String?,
      option: fields[2] as String?,
      title: fields[3] as String?,
      status: fields[4] as String?,
      selfPickUp: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveRating obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.resId)
      ..writeByte(2)
      ..write(obj.option)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.selfPickUp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveRatingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
