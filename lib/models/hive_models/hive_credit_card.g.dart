// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_credit_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveCreditCardAdapter extends TypeAdapter<HiveCreditCard> {
  @override
  final int typeId = 6;

  @override
  HiveCreditCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveCreditCard(
      cardNumber: fields[0] as String?,
      expiryDate: fields[1] as String?,
      cardHolderName: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveCreditCard obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.cardNumber)
      ..writeByte(1)
      ..write(obj.expiryDate)
      ..writeByte(2)
      ..write(obj.cardHolderName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveCreditCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
