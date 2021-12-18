import 'package:json_annotation/json_annotation.dart';
part 'volume.g.dart';

@JsonSerializable()
class Volume {
  Volume({
    this.id,
    this.volumeName,
    this.price,
    this.groupId,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'volume')
  final String? volumeName;

  @JsonKey(name: 'price')
  final num? price;

  @JsonKey(name: 'group')
  final int? groupId;

  factory Volume.fromJson(Map<String, dynamic> json) => _$VolumeFromJson(json);

  Map<String, dynamic> toJson() => _$VolumeToJson(this);
}
