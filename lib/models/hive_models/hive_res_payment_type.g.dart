// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_res_payment_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveResPaymentTypeAdapter extends TypeAdapter<HiveResPaymentType> {
  @override
  final int typeId = 4;

  @override
  HiveResPaymentType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveResPaymentType(
      id: fields[0] as int?,
      nameTk: fields[1] as String?,
      nameRu: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveResPaymentType obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nameTk)
      ..writeByte(2)
      ..write(obj.nameRu);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveResPaymentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
