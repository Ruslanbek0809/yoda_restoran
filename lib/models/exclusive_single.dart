import 'package:json_annotation/json_annotation.dart';
part 'exclusive_single.g.dart';

@JsonSerializable(includeIfNull: true)
class ExclusiveSingle {
  ExclusiveSingle({
    this.id,
    this.order,
    this.name,
    this.image,
    this.imageRu,
    this.option,
    this.url,
  });

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'order')
  final int? order;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'image')
  final String? image;

  @JsonKey(name: 'imageRu')
  final String? imageRu;

  @JsonKey(name: 'option')
  final String? option;

  @JsonKey(name: 'url')
  final String? url;

  factory ExclusiveSingle.fromJson(Map<String, dynamic> json) =>
      _$ExclusiveSingleFromJson(json);

  Map<String, dynamic> toJson() => _$ExclusiveSingleToJson(this);
}
