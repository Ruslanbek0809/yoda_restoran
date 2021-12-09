import 'package:json_annotation/json_annotation.dart';

import 'models.dart';
part 'main_volume.g.dart';

@JsonSerializable()
class MainVolume {
  MainVolume({
    this.id,
    this.name,
    this.mealId,
    this.volumes,
  });

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'meal')
  final int? mealId;

  @JsonKey(name: 'volumes')
  final List<Volume>? volumes;

  factory MainVolume.fromJson(Map<String, dynamic> json) =>
      _$MainVolumeFromJson(json);

  Map<String, dynamic> toJson() => _$MainVolumeToJson(this);
}
