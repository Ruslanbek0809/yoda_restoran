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
      imageCard: fields[2] as String?,
      name: fields[3] as String?,
      price: fields[4] as num?,
      discount: fields[5] as int?,
      discountedPrice: fields[6] as num?,
      quantity: fields[7] as int?,
      volumes: (fields[8] as List?)?.cast<HiveVolCus>(),
      customs: (fields[9] as List?)?.cast<HiveVolCus>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveMeal obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.imageCard)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.discount)
      ..writeByte(6)
      ..write(obj.discountedPrice)
      ..writeByte(7)
      ..write(obj.quantity)
      ..writeByte(8)
      ..write(obj.volumes)
      ..writeByte(9)
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
