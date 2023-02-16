// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_restaurant.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveRestaurantAdapter extends TypeAdapter<HiveRestaurant> {
  @override
  final int typeId = 1;

  @override
  HiveRestaurant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveRestaurant(
      id: fields[0] as int?,
      image: fields[1] as String?,
      name: fields[2] as String?,
      address: fields[3] as String?,
      rated: fields[4] as int?,
      rating: fields[5] as num?,
      deliveryPrice: fields[6] as num?,
      description: fields[7] as String?,
      notification: fields[8] as String?,
      workingHours: fields[9] as String?,
      phoneNumber: fields[10] as String?,
      prepareTime: fields[11] as String?,
      city: fields[12] as String?,
      distance: fields[13] as num?,
      selfPickUp: fields[14] as bool?,
      delivery: fields[15] as bool?,
      resPaymentTypes: (fields[16] as List?)?.cast<HiveResPaymentType>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveRestaurant obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.rated)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.deliveryPrice)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.notification)
      ..writeByte(9)
      ..write(obj.workingHours)
      ..writeByte(10)
      ..write(obj.phoneNumber)
      ..writeByte(11)
      ..write(obj.prepareTime)
      ..writeByte(12)
      ..write(obj.city)
      ..writeByte(13)
      ..write(obj.distance)
      ..writeByte(14)
      ..write(obj.selfPickUp)
      ..writeByte(15)
      ..write(obj.delivery)
      ..writeByte(16)
      ..write(obj.resPaymentTypes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveRestaurantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
