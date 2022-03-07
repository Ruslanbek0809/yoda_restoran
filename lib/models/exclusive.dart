import 'package:json_annotation/json_annotation.dart';
import 'exclusive_single.dart';
import 'models.dart';

part 'exclusive.g.dart';

@JsonSerializable(includeIfNull: true)
class Exclusive {
  Exclusive({
    this.id,
    this.position,
    this.name,
    this.order,
    this.exclusiveSingles,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'position')
  final int? position;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'order')
  final int? order;

  @JsonKey(name: 'exclusives')
  final List<ExclusiveSingle>? exclusiveSingles;

  factory Exclusive.fromJson(Map<String, dynamic> json) =>
      _$ExclusiveFromJson(json);

  Map<String, dynamic> toJson() => _$ExclusiveToJson(this);
}
