// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RoomType.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoomClassAdapter extends TypeAdapter<RoomClass> {
  @override
  final int typeId = 0;

  @override
  RoomClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoomClass(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RoomClass obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
