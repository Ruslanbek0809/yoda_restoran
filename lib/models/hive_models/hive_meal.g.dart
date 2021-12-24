// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_meal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveMealAdapter extends TypeAdapter<HiveMeal> {
  @override
  final int typeId = 0;

  @override
  HiveMeal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveMeal(
      id: fields[0] as int?,
      image: fields[1] as String?,
      name: fields[2] as String?,
      price: fields[3] as num?,
      discount: fields[4] as int?,
      discountedPrice: fields[5] as num?,
      quantity: fields[6] as int?,
      volumes: (fields[7] as List?)?.cast<HiveVolCus>(),
      customs: (fields[8] as List?)?.cast<HiveVolCus>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveMeal obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.discount)
      ..writeByte(5)
      ..write(obj.discountedPrice)
      ..writeByte(6)
      ..write(obj.quantity)
      ..writeByte(7)
      ..write(obj.volumes)
      ..writeByte(8)
      ..write(obj.customs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveMealAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
