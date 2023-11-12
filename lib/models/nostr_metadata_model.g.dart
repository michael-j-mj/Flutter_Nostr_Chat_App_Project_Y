// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nostr_metadata_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NostrMetadataAdapter extends TypeAdapter<NostrMetadata> {
  @override
  final int typeId = 4;

  @override
  NostrMetadata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NostrMetadata(
      pubkey: fields[0] as String,
      displayName: fields[1] as String,
      website: fields[2] as String,
      name: fields[3] as String,
      about: fields[4] as String,
      picture: fields[5] as String,
      createAt: fields[8] as DateTime,
      id: fields[6] as String,
      bannerURL: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, NostrMetadata obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.pubkey)
      ..writeByte(1)
      ..write(obj.displayName)
      ..writeByte(2)
      ..write(obj.website)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.about)
      ..writeByte(5)
      ..write(obj.picture)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(8)
      ..write(obj.createAt)
      ..writeByte(9)
      ..write(obj.bannerURL);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NostrMetadataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
